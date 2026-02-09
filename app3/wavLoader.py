import numpy as np
import scipy.io.wavfile as wavfile


def load_wav(file_path) -> tuple[int, np.ndarray]:
    sample_rate, data = wavfile.read(file_path)
    return sample_rate, data


def load_guitare() -> tuple[int, np.ndarray]:
    return load_wav("./sounds/note_guitare_lad.wav")


def load_basson() -> tuple[int, np.ndarray]:
    return load_wav("./sounds/note_basson_plus_sinus_1000_hz.wav")


if __name__ == "__main__":
    print("Running wavLoader functions:")
    print()
    sample_rate, data = load_guitare()
    print(f" - Guitar Sample rate: {sample_rate} Hz")
    print(f" - Guitar Data shape: {data.shape}")
    print()
    sample_rate, data = load_basson()
    print(f" - Bassoon Sample rate: {sample_rate} Hz")
    print(f" - Bassoon Data shape: {data.shape}")
