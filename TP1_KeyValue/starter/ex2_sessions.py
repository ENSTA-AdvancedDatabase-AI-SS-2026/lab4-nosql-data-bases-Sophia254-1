"""
TP1 - Exercice 2 : Gestion des sessions utilisateur
Use Case : Sessions ShopFast avec expiration automatique
"""

import redis
import uuid
import time

r = redis.Redis(host='localhost', port=6379, decode_responses=True)

SESSION_TTL = 1800  # 30 minutes


def create_session(r, user_id):
    """
    Créer une session utilisateur avec TTL
    
    Clé : "session:{session_id}"
    Valeur : user_id
    
    Retourner le session_id généré
    """
    
    session_id = str(uuid.uuid4())

    key = f"session:{session_id}"

    r.set(key, user_id, ex=SESSION_TTL)

    return session_id


def get_session(r, session_id):
    """
    Récupérer une session
    
    Si la session existe :
    - renouveler son TTL (sliding expiration)
    - retourner le user_id
    
    Sinon retourner None
    """
    
    key = f"session:{session_id}"

    user_id = r.get(key)

    if user_id:
        r.expire(key, SESSION_TTL)
        return user_id

    return None


def delete_session(r, session_id):
    """
    Supprimer une session
    """
    
    key = f"session:{session_id}"

    r.delete(key)


def session_exists(r, session_id):
    """
    Vérifier si une session existe
    """
    
    return r.exists(f"session:{session_id}") == 1


if __name__ == "__main__":

    r.flushdb()

    print("=== TEST SESSIONS ===")

    session = create_session(r, "user:42")

    print("Session créée :", session)

    print("Session récupérée :", get_session(r, session))

    print("Existe ?", session_exists(r, session))

    delete_session(r, session)

    print("Après suppression :", session_exists(r, session))