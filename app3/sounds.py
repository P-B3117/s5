import numpy as np
import scipy.io.wavfile as wavfile


def save_wav(file_path, sample_rate: int, data: np.ndarray) -> None:
    wavfile.write(file_path, sample_rate, np.int16(data / np.max(np.abs(data)) * 32767))


def load_wav(file_path) -> tuple[int, np.ndarray]:
    sample_rate, data = wavfile.read(file_path)
    return sample_rate, data


def load_guitare() -> tuple[int, np.ndarray]:
    return load_wav("./sounds/note_guitare_lad.wav")


def load_basson() -> tuple[int, np.ndarray]:
    return load_wav("./sounds/note_basson_plus_sinus_1000_hz.wav")


if __name__ == "__main__":
    sample_rate, data = load_guitare()
    print(f" - Guitare Sample rate: {sample_rate} Hz")
    print(f" - Guitare Data size: {len(data)}")
    print()
    sample_rate, data = load_basson()
    print(f" - Basson Sample rate: {sample_rate} Hz")
    print(f" - Basson Data size: {len(data)}")
