#  Les lignes de code en Python où vous appliquez la matrice de rotation aux coordonnées de l’image (GIF592 : 4 points)
#  La matrice de passage P qui permettrait d’obtenir l’image tournée et comment l’obtenir (GIF592 : 3 points)
#  {⃗u1, ⃗u2} exprimés comme une combinaison linéaire de {⃗e1, ⃗e2} (GIF592 : 3 points)
#  Deux images : une avant rotation et l’autre après rotation de 90 degrés vers la droite. (GIF592 : 10 points)

import matplotlib.pyplot as plt
import numpy as np

from assets import load_image


def rotation_matrix(angle):
    return np.array([[np.cos(angle), -np.sin(angle)], [np.sin(angle), np.cos(angle)]])


def change_image_base(image, matrix):
    width, height = image.shape[:2]
    new_image = np.zeros((height, width, *image.shape[2:]), dtype=image.dtype)

    for y in range(height):
        for x in range(width):
            new = matrix @ np.array([width - x - 1, height - y - 1])
            new_x = int(round(new[0]))
            new_y = int(round(new[1]))
            new_image[new_y, new_x] = image[height - y - 1, width - x - 1]

    return new_image


if __name__ == "__main__":
    rotation = rotation_matrix(np.pi / 2)

    image = load_image("goldhill_rotate.png")
    rotated = change_image_base(image, rotation)

    plt.subplot(2, 1, 1)
    plt.title("Original Image")
    plt.imshow(image)
    plt.axis("off")

    plt.subplot(2, 1, 2)
    plt.title("Rotated Image")
    plt.imshow(rotated)
    plt.axis("off")

    try:
        plt.show()
    except KeyboardInterrupt:
        plt.close("all")


def test_rotation_matrix():
    """Makes sure that the rotation matrix is correct."""
    np.testing.assert_array_almost_equal(
        rotation_matrix(np.pi / 2), np.array([[0, -1], [1, 0]])
    )
    np.testing.assert_array_almost_equal(
        rotation_matrix(np.pi), np.array([[-1, 0], [0, -1]])
    )
    np.testing.assert_array_almost_equal(
        rotation_matrix(np.pi / 2 * 3), np.array([[0, 1], [-1, 0]])
    )
    np.testing.assert_array_almost_equal(
        rotation_matrix(2 * np.pi), np.array([[1, 0], [0, 1]])
    )


def test_rotation():
    """Makes sure that the image is correctly rotated."""
    image = load_image("goldhill_rotate.png")

    rotation = rotation_matrix(np.pi / 2)
    rotated = change_image_base(image, rotation)
    rotated = change_image_base(rotated, rotation)

    rotation = rotation_matrix(-np.pi)
    rotated = change_image_base(rotated, rotation)

    np.testing.assert_array_almost_equal(rotated, image)
