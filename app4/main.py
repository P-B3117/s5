from scipy import signal
import matplotlib.pyplot as plt
import numpy as np

from correctionAberrations import filter_Hz
from assets import load_array
from rotation import change_image_base, rotation_matrix
from debruitage import digital_filter_by_hand

if __name__ == "__main__":
    image = load_array("image_complete.npy")

    # Correction des aberrations
    den, num = filter_Hz()
    img_corrected = signal.lfilter(num, den, image)

    # Rotation de l'image corrigée
    rotation = rotation_matrix(np.pi / 2)
    img_rotated = change_image_base(img_corrected, rotation)

    # Débruitage
    img_filtered = digital_filter_by_hand(img_rotated)

    # Compression
    img_compressed = img_filtered

    # Affichage des résultats
    plt.gray()
    plt.subplot(2, 1, 1)
    plt.title("Original Image")
    plt.imshow(image)
    plt.axis("off")

    plt.subplot(2, 1, 2)
    plt.title("Final Image")
    plt.imshow(img_compressed)
    plt.axis("off")

    try:
        plt.show()
    except KeyboardInterrupt:
        plt.close("all")
