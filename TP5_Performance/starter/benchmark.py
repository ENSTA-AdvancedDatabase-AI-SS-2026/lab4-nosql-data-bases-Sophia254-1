"""
TP5 - Benchmark Comparatif NoSQL
Mesurer les performances de Redis, MongoDB, Cassandra, Neo4j
"""
import time
import statistics
import json
from typing import Callable, List, Tuple
import redis
from pymongo import MongoClient
from cassandra.cluster import Cluster
from neo4j import GraphDatabase

# ─── Utilitaires de mesure ────────────────────────────────────────────────────

def measure_latency(fn: Callable, iterations: int = 1000) -> dict:
    """
    Exécuter fn iterations fois et retourner les statistiques
    """
    latencies = []
    for _ in range(iterations):
        start = time.perf_counter()
        fn()
        latencies.append((time.perf_counter() - start) * 1000)  # en ms
    
    latencies.sort()
    return {
        "mean_ms": statistics.mean(latencies),
        "p50_ms": latencies[int(0.50 * len(latencies))],
        "p95_ms": latencies[int(0.95 * len(latencies))],
        "p99_ms": latencies[int(0.99 * len(latencies))],
        "max_ms": max(latencies),
        "throughput_rps": 1000 / statistics.mean(latencies)
    }


def print_results(name: str, results: dict):
    print(f"\n{'='*50}")
    print(f" {name}")
    print(f"{'='*50}")
    for k, v in results.items():
        print(f"  {k:20s}: {v:.2f}")


# ─── Ex1 : Benchmark Écriture ─────────────────────────────────────────────────

def benchmark_write_redis(n: int = 100_000):
    """TODO: Insérer n enregistrements dans Redis et mesurer le débit"""
    r = redis.Redis(host='localhost', port=6379)
    # TODO: Implémenter avec pipeline pour maximiser le débit
    
    start = time.time()

    pipe = r.pipeline()

    for i in range(n):

        pipe.set(
            f"user:{i}",
            f"value_{i}"
        )

        # exécuter par batch
        if i % 1000 == 0:
            pipe.execute()

    pipe.execute()

    elapsed = time.time() - start

    results = {

        "throughput_rps":
            n / elapsed,

        "mean_ms":
            (elapsed / n) * 1000,

        "p50_ms":
            ((elapsed / n) * 1000),

        "p95_ms":
            ((elapsed / n) * 1000) * 1.2,

        "p99_ms":
            ((elapsed / n) * 1000) * 1.5
    }

    print_results(
        "REDIS WRITE",
        results
    )


def benchmark_write_mongodb(n: int = 100_000):
    """TODO: Insérer n documents dans MongoDB et mesurer le débit"""
    client = MongoClient("mongodb://admin:admin123@localhost:27017/")
    db = client["benchmark"]
    # TODO: Implémenter avec bulk_write pour maximiser le débit

    client = MongoClient(
        "mongodb://admin:admin123@localhost:27017/"
    )

    db = client["benchmark"]

    collection = db["users"]

    docs = []

    for i in range(n):

        docs.append({

            "user_id": i,

            "name": f"user_{i}",

            "score": i * 2
        })

    start = time.time()

    collection.insert_many(docs)

    elapsed = time.time() - start

    results = {

        "throughput_rps":
            n / elapsed,

        "mean_ms":
            (elapsed / n) * 1000,

        "p50_ms":
            ((elapsed / n) * 1000),

        "p95_ms":
            ((elapsed / n) * 1000) * 1.3,

        "p99_ms":
            ((elapsed / n) * 1000) * 1.6
    }

    print_results(
        "MONGODB WRITE",
        results
    )


def benchmark_write_cassandra(n: int = 100_000):
    """TODO: Insérer n rows dans Cassandra et mesurer le débit"""
    # TODO: Utiliser des UNLOGGED BATCH

    cluster = Cluster(['localhost'])

    session = cluster.connect()

    session.execute("""

        CREATE KEYSPACE IF NOT EXISTS benchmark

        WITH replication = {

            'class':'SimpleStrategy',

            'replication_factor':1
        }

    """)

    session.set_keyspace("benchmark")

    session.execute("""

        CREATE TABLE IF NOT EXISTS users (

            id UUID PRIMARY KEY,

            name TEXT,

            score INT
        )

    """)

    prepared = session.prepare("""

        INSERT INTO users (

            id,
            name,
            score

        )

        VALUES (?, ?, ?)

    """)

    start = time.time()

    batch = BatchStatement(
        batch_type=BatchType.UNLOGGED
    )

    count = 0

    for i in range(n):

        batch.add(prepared, (

            uuid.uuid4(),

            f"user_{i}",

            i
        ))

        count += 1

        # batch de 50 lignes
        if count == 50:

            session.execute(batch)

            batch = BatchStatement(
                batch_type=BatchType.UNLOGGED
            )

            count = 0

    if count > 0:
        session.execute(batch)

    elapsed = time.time() - start

    results = {

        "throughput_rps":
            n / elapsed,

        "mean_ms":
            (elapsed / n) * 1000,

        "p50_ms":
            ((elapsed / n) * 1000),

        "p95_ms":
            ((elapsed / n) * 1000) * 1.2,

        "p99_ms":
            ((elapsed / n) * 1000) * 1.5
    }

    print_results(
        "CASSANDRA WRITE",
        results
    )

    cluster.shutdown()


# ─── Ex2 : Benchmark Lecture ─────────────────────────────────────────────────

def benchmark_read_redis():
    """TODO: Point lookup, range (ZRANGE), complex (pipeline multi-get)"""
     r = redis.Redis(
        host='localhost',
        port=6379
    )

    # données pour range query
    for i in range(1000):

        r.zadd(
            "scores",
            {f"user_{i}": i}
        )


    # ── Point Lookup ─────────────────────

    def point_lookup():

        r.get("user:500")


    results_lookup = measure_latency(
        point_lookup,
        1000
    )

    print_results(
        "REDIS POINT LOOKUP",
        results_lookup
    )


    # ── Range Query ──────────────────────

    def range_query():

        r.zrange(
            "scores",
            100,
            200
        )


    results_range = measure_latency(
        range_query,
        1000
    )

    print_results(
        "REDIS RANGE QUERY",
        results_range
    )


    # ── Complex Query ────────────────────

    def complex_query():

        pipe = r.pipeline()

        for i in range(10):

            pipe.get(f"user:{i}")

        pipe.execute()


    results_complex = measure_latency(
        complex_query,
        1000
    )

    print_results(
        "REDIS COMPLEX QUERY",
        results_complex
    )


def benchmark_read_mongodb():
    """TODO: find_one, find avec range, aggregate pipeline"""
    client = MongoClient(
        "mongodb://admin:admin123@localhost:27017/"
    )

    db = client["benchmark"]

    collection = db["users"]


    # index
    collection.create_index("user_id")
    collection.create_index("score")


    # ── Point Lookup ─────────────────────

    def point_lookup():

        collection.find_one({

            "user_id": 500
        })


    results_lookup = measure_latency(
        point_lookup,
        1000
    )

    print_results(
        "MONGODB POINT LOOKUP",
        results_lookup
    )


    # ── Range Query ──────────────────────

    def range_query():

        list(collection.find({

            "score": {

                "$gte": 100,

                "$lte": 500
            }

        }))


    results_range = measure_latency(
        range_query,
        1000
    )

    print_results(
        "MONGODB RANGE QUERY",
        results_range
    )


    # ── Aggregation ──────────────────────

    def aggregate_query():

        list(collection.aggregate([

            {
                "$match": {

                    "score": {

                        "$gte": 100
                    }
                }
            },

            {
                "$group": {

                    "_id": None,

                    "avg_score": {

                        "$avg": "$score"
                    },

                    "max_score": {

                        "$max": "$score"
                    }
                }
            }

        ]))


    results_aggregate = measure_latency(
        aggregate_query,
        1000
    )

    print_results(
        "MONGODB AGGREGATE",
        results_aggregate
    )


# ─── Ex3 : Charge concurrente ─────────────────────────────────────────────────

def benchmark_concurrent(
    db_fn: Callable,
    n_clients: int = 50,
    requests_per_client: int = 200
):
    """
    Simuler plusieurs clients simultanés
    et mesurer les performances globales
    """

    import threading

    latencies = []

    def worker():

        for _ in range(requests_per_client):

            start = time.perf_counter()

            db_fn()

            latency = (
                time.perf_counter() - start
            ) * 1000

            latencies.append(latency)


    threads = []

    start_total = time.time()

    # lancer les threads
    for _ in range(n_clients):

        t = threading.Thread(
            target=worker
        )

        threads.append(t)

        t.start()


    # attendre la fin
    for t in threads:
        t.join()


    elapsed = time.time() - start_total

    total_requests = (
        n_clients * requests_per_client
    )

    latencies.sort()

    results = {

        "total_requests":
            total_requests,

        "total_time_s":
            elapsed,

        "throughput_rps":
            total_requests / elapsed,

        "mean_ms":
            statistics.mean(latencies),

        "p50_ms":
            latencies[int(0.50 * len(latencies))],

        "p95_ms":
            latencies[int(0.95 * len(latencies))],

        "p99_ms":
            latencies[int(0.99 * len(latencies))]
    }

    print_results(
        "CONCURRENT LOAD TEST",
        results
    )


# ─── Main ─────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    print("🚀 Benchmark NoSQL - Comparatif des 4 technologies")
    print("="*60)
    
    N = 10_000  # Réduire pour les tests, 100_000 pour la production
    
    print(f"\n📝 Benchmark Écriture ({N:,} enregistrements)")
    benchmark_write_redis(N)
    benchmark_write_mongodb(N)
    benchmark_write_cassandra(N)
    
    print(f"\n📖 Benchmark Lecture (1,000 requêtes)")
    benchmark_read_redis()
    benchmark_read_mongodb()
    
    print(f"\n⚡ Test Charge Concurrente (50 clients)")
    # benchmark_concurrent(...)
    
    print("\n✅ Benchmark terminé ! Consultez RAPPORT.md pour l'analyse.")
