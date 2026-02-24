import matplotlib.pyplot as plt
import numpy as np
from scipy import signal

from assets import load_array, save_image
from compressionCharles import process_image
from correctionAberrations import filter_Hz
from debruitage import digital_filter, digital_filter_by_hand
from rotation import change_image_base, rotation_matrix

if __name__ == "__main__":
    image = load_array("image_complete.npy")
    save_image(image, "presentation/original.png")

    # Correction des aberrations
    den, num = filter_Hz()
    img_corrected = signal.lfilter(num, den, image)
    save_image(img_corrected, "presentation/corrected.png")

    # Rotation de l'image corrigée
    rotation = rotation_matrix(np.pi / 2)
    img_rotated = change_image_base(img_corrected, rotation)
    save_image(img_rotated, "presentation/rotated.png")

    # Débruitage
    img_filtered_hand = digital_filter_by_hand(img_rotated)
    img_filtered_ellip = digital_filter(img_rotated, "elliptic")

    save_image(img_filtered_hand, "presentation/pas_bruit_main.png")
    save_image(img_filtered_ellip, "presentation/pas_bruit_ellip.png")

    # Compression
    img_compressed = img_filtered_hand
    processed_img = process_image(img_compressed, keep_ratio=0.5)
    save_image(processed_img, "presentation/compressed.png")
    processed_img = process_image(img_compressed, keep_ratio=0.7)
    save_image(processed_img, "presentation/compressed70.png")

    try:
        np.testing.assert_array_equal(processed_img, img_compressed)
        print("Compression failed (same image)")
    except AssertionError:
        print("Compression successful")
    else:
        print("Compression failed")

    # Affichage des résultats
    plt.figure()
    plt.gray()
    plt.subplot(2, 1, 1)
    plt.title("Original Image")
    plt.imshow(image)
    plt.axis("off")

    plt.subplot(2, 1, 2)
    plt.title("Final Image")
    plt.imshow(processed_img)
    plt.axis("off")

    try:
        plt.show()
    except KeyboardInterrupt:
        plt.close("all")
