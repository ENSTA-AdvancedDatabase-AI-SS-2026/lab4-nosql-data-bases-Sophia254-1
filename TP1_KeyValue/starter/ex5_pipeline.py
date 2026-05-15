"""
TP1 - Exercice 5 : Pipeline & Transactions Redis
Use Case : Traitement de commandes ShopFast
"""

import redis

r = redis.Redis(host='localhost', port=6379, decode_responses=True)


def bulk_insert_products(r, products):
    """
    Insérer plusieurs produits avec un pipeline
    
    products = [
        {"id": 1, "name": "...", "price": ...},
        ...
    ]
    """

    pipe = r.pipeline()

    for product in products:

        key = f"product:{product['id']}"

        pipe.hset(key, mapping={
            "name": product["name"],
            "price": product["price"]
        })

    pipe.execute()

    return True


def process_order(r, user_id, product_id, quantity):
    """
    Transaction atomique :
    
    - vérifier le stock
    - diminuer le stock
    - supprimer le produit du panier
    
    Utiliser WATCH + MULTI + EXEC
    """

    stock_key = f"stock:{product_id}"
    cart_key = f"cart:{user_id}"

    with r.pipeline() as pipe:

        while True:

            try:
                pipe.watch(stock_key)

                stock = int(r.get(stock_key) or 0)

                if stock < quantity:
                    pipe.unwatch()
                    return "Stock insuffisant"

                pipe.multi()

                pipe.decrby(stock_key, quantity)

                pipe.hdel(cart_key, product_id)

                pipe.execute()

                return "Commande validée"

            except redis.WatchError:
                print("Conflit détecté, nouvelle tentative...")


if __name__ == "__main__":

    r.flushdb()

    print("=== TEST PIPELINE ===")

    products = [
        {"id": 1, "name": "Samsung A54", "price": 65000},
        {"id": 2, "name": "Laptop HP", "price": 120000},
        {"id": 3, "name": "Casque JBL", "price": 12000},
    ]

    bulk_insert_products(r, products)

    print("Produits insérés")

    # Préparer stock
    r.set("stock:1", 10)

    # Préparer panier
    r.hset("cart:user42", "1", 2)

    print(process_order(r, "user42", "1", 2))

    print("Stock restant :", r.get("stock:1"))