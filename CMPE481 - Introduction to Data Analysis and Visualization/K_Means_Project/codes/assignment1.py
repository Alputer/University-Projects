import random
import math
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.datasets import make_blobs
import numpy as np


class Point:
    def __init__(self, x: float, y: float):
        self.x = float(x)
        self.y = float(y)

    def __str__(self):
        return f"{self.x},{self.y}"


def generate_data_not_suitable_for_clustering(filename):
    # Number of data points
    num_points = 500

    # Radius of the circle
    radius1 = 5.0
    radius2 = 6.0
    radius3 = 7.0

    # Generate evenly spaced angles
    angles = [2 * math.pi * i / num_points for i in range(num_points)]

    # Calculate x and y coordinates for the points
    x1 = [radius1 * math.cos(angle) for angle in angles]
    y1 = [radius1 * math.sin(angle) for angle in angles]
    x2 = [radius2 * math.cos(angle) for angle in angles]
    y2 = [radius2 * math.sin(angle) for angle in angles]
    x3 = [radius3 * math.cos(angle) for angle in angles]
    y3 = [radius3 * math.sin(angle) for angle in angles]
    x = x1 + x2 + x3
    y = y1 + y2 + y3

    with open(filename, "w") as file:
        for i in range(len(x)):
            line = f"{x[i]}, {y[i]}\n"
            file.write(line)
    # Plot the data points
    plt.scatter(x, y)
    plt.axis("equal")  # Equal scaling for x and y axes to make it a circle
    plt.title("Circular Data Points")
    plt.show()


def generate_data_suitable_for_clustering(filename):
    # Set random seed for reproducibility
    np.random.seed(0)

    # Generate synthetic data
    n_samples = 2000
    n_features = 2
    n_clusters = 4

    X, y = make_blobs(
        n_samples=n_samples, n_features=n_features, centers=n_clusters, random_state=0
    )

    with open(filename, "w") as file:
        for i in range(n_samples):
            line = f"{X[i, 0]}, {X[i, 1]}\n"
            file.write(line)

    # Visualize the generated data
    plt.scatter(X[:, 0], X[:, 1], c=y, cmap="viridis")
    plt.title("Generated Data for Clustering")
    plt.xlabel("Feature 1")
    plt.ylabel("Feature 2")
    plt.show()


def read_data(file_name):
    data = []
    with open(file_name, "r") as file:
        lines = file.readlines()
        for line in lines:
            [x, y] = line.split(",")
            data.append(Point(x, y))
    return data


def convert_data(data):
    result = []
    for point in data:
        result.append([point.x, point.y])
    return result


def objective_function(clusters):
    result = 0
    for cluster in clusters:
        result += squared_euclidean_distance_sum(cluster)
    return result


def squared_euclidean_distance_sum(cluster):
    centroid = Point(
        sum(point.x for point in cluster) / len(cluster),
        sum(point.y for point in cluster) / len(cluster),
    )

    objective_function = 0
    for point in cluster:
        objective_function += euclidean_distance(point, centroid) ** 2

    return objective_function


def show_objective_function(objective_functions, title):
    indexes = list(range(1, len(objective_functions) + 1))

    # Create a simple line plot
    plt.plot(indexes, objective_functions, marker="o")

    # Label the axes
    plt.xlabel("Iteration")
    plt.ylabel("Objective Function")

    plt.title(title)
    # Show the plot
    plt.show()


def show_clusters(clusters, centroids, title):
    colors = ["red", "green", "blue", "purple", "yellow", "orange", "pink"] * 10
    for i, cluster in enumerate(clusters):
        x_values = [point.x for point in cluster]
        y_values = [point.y for point in cluster]
        plt.scatter(x_values, y_values, c=colors[i], label=f"Cluster {i}")

    x_values = [point.x for point in centroids]
    y_values = [point.y for point in centroids]
    plt.scatter(x_values, y_values, c="black", label=f"Centroids")

    # Add legend
    plt.legend()

    plt.title(title)

    # Display the plot
    plt.show()


def euclidean_distance(point1, point2):
    return ((point1.x - point2.x) ** 2 + (point1.y - point2.y) ** 2) ** 0.5


def initialize_centroids(data, k):
    centroids = random.sample(data, k)
    return centroids


def centroids_difference(new_centroids, centroids):
    result = 0
    for new_centroid, old_centroid in zip(new_centroids, centroids):
        result += euclidean_distance(new_centroid, old_centroid)

    return result


def assign_to_clusters(data, centroids):
    clusters = [[] for _ in range(len(centroids))]
    for point in data:
        closest_centroid = min(
            centroids, key=lambda centroid: euclidean_distance(point, centroid)
        )

        cluster_index = -1
        for index, centroid in enumerate(centroids):
            if centroid == closest_centroid:
                cluster_index = index
                break

        clusters[cluster_index].append(point)
    return clusters


def update_centroids(clusters):
    new_centroids = []
    for cluster in clusters:
        centroid = Point(
            sum(point.x for point in cluster) / len(cluster),
            sum(point.y for point in cluster) / len(cluster),
        )
        new_centroids.append(centroid)

    return new_centroids


def find_centroids(clusters):
    new_centroids = []
    for cluster in clusters:
        centroid = [
            sum(point[0] for point in cluster) / len(cluster),
            sum(point[1] for point in cluster) / len(cluster),
        ]
        new_centroids.append(centroid)

    return new_centroids


def k_means(data, k, max_iterations=100, display=True):
    objective_function_vals = []
    centroids = initialize_centroids(data, k)

    for i in range(max_iterations):
        clusters = assign_to_clusters(data, centroids)
        new_centroids = update_centroids(clusters)
        objective_function_vals.append(objective_function(clusters))
        if i < 3:
            if display:
                show_clusters(clusters, new_centroids, f"Iteration {i+1} for k={k}")

        # Check for convergence
        if centroids_difference(new_centroids, centroids) < 0.001:
            if display:
                show_clusters(clusters, centroids, "Final iteration")
                show_objective_function(
                    objective_function_vals,
                    f"Objective function vs iteration count for k={k}",
                )
            break

        centroids = new_centroids

    return [clusters, centroids]


def k_means_scikit(data, k, display=True):
    kmeans = KMeans(n_clusters=k)
    data = convert_data(data)
    kmeans.fit(data)
    cluster_labels = kmeans.labels_
    clusters = []

    for i in range(k):
        cluster = []
        for j in range(len(data)):
            if str(cluster_labels[j]) == str(i):
                cluster.append(data[j])
        clusters.append(cluster)
    if display:
        colors = ["red", "green", "blue", "purple", "yellow", "orange", "black"]
        for i, cluster in enumerate(clusters):
            x_values = [point[0] for point in cluster]
            y_values = [point[1] for point in cluster]
            plt.scatter(x_values, y_values, c=colors[i], label=f"Cluster {i}")
        centroids = find_centroids(clusters)
        x_values = [point[0] for point in centroids]
        y_values = [point[1] for point in centroids]
        plt.scatter(x_values, y_values, c="black", label=f"Centroids")

        # Add legend
        plt.legend()
        plt.title(f"Clustering result of scikit for k={k}")
        # Display the plot
        plt.show()


# Use elbow method
def find_optimal_k(data, search_range=[1, 10]):
    costs = []
    for i in range(search_range[0], search_range[1]):
        [clusters, _] = k_means(data, i, display=False)
        cost = 0
        for cluster in clusters:
            centroid = Point(
                sum(point.x for point in cluster) / len(cluster),
                sum(point.y for point in cluster) / len(cluster),
            )
            for point in cluster:
                cost += euclidean_distance(point, centroid)
        costs.append(cost)
    show_objective_function(costs, "Elbow Point Method")


if __name__ == "__main__":
    filename = "cluster_data.txt"
    k = 4
    mode = 3

    if mode == 1:
        generate_data_suitable_for_clustering(filename)
    elif mode == 2:
        generate_data_not_suitable_for_clustering(filename)
    elif mode == 3:
        data = read_data(filename)
        k_means(data, k)
    elif mode == 4:
        data = read_data(filename)
        k_means_scikit(data, k)
    elif mode == 5:
        data = read_data(filename)
        find_optimal_k(data)
    else:
        raise Exception("Enter a valid mode")
