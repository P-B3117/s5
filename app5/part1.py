from typing import Callable

import numpy as np


class wheel:
    def __init__(self, range):
        self.result = 0
        self.range = range

    def roll(self) -> int:
        self.result = np.random.randint(0, self.range)
        return self.result


class machine_a_sous:
    def __init__(self, wheels: list[wheel]):
        self.wheels = wheels

    def roll(self) -> list[int]:
        return [wheel.roll() for wheel in self.wheels]


class approche:
    def __init__(
        self,
        machine: machine_a_sous,
        conditions: list[Callable[[list[int]], bool]],
        num_rolls: int = 1,
        min_successes: int = 1,
    ):
        self.machine = machine
        self.conditions = conditions
        self.num_rolls = num_rolls
        self.min_successes = min_successes

    def single_run(self) -> bool:
        roll = self.machine.roll()

        for condition in self.conditions:
            if condition(roll):
                return True
        return False

    def run(self) -> bool:
        successes = 0
        for _ in range(self.num_rolls):
            if self.single_run():
                successes += 1
                if successes >= self.min_successes:
                    return True
        return False


def condition_same(input: list[int]) -> bool:
    same = True
    for inp in input:
        if inp != input[0]:
            same = False
            break

    return same


def condition_different(input: list[int]) -> bool:
    diff: bool = True

    def different(input: list[int], check: int) -> bool:
        for inp in input:
            if inp == check:
                return False
        return True

    for inp in input:
        if not different(input, inp):
            diff = False
            break

    return diff


cas_i1 = approche(
    machine_a_sous([wheel(8) for _ in range(3)]),
    [condition_same],
)
cas_i2 = approche(
    machine_a_sous([wheel(5) for _ in range(4)]),
    [condition_same],
)

cas_ii1 = approche(
    machine_a_sous([wheel(8) for _ in range(3)]),
    [condition_different],
)
cas_ii2 = approche(
    machine_a_sous([wheel(5) for _ in range(4)]),
    [condition_different],
)

cas_i1 = approche(
    machine_a_sous([wheel(8) for _ in range(3)]),
    [condition_same],
    num_rolls=5,
    min_successes=2,
)
cas_i2 = approche(
    machine_a_sous([wheel(5) for _ in range(4)]),
    [condition_same],
    num_rolls=5,
    min_successes=2,
)


def probs_same(N: int, m: int) -> float:
    """
    N: number of trials
    m: number of possible outcomes
    """
    total: float = 1.0

    for _ in range(N):
        total *= 1 / m

    return total


def probs_different(N: int, m: int) -> float:
    """
    N: number of trials
    m: number of possible outcomes
    """
    total: float = 1.0

    for i in range(N):
        total *= (m - (i)) / m

    return total


def binomial_distribution_mass(x: int, n: int, p: float) -> float:
    """
    x: number of successes
    n: number of trials
    p: probability of success
    """
    return p**x * (1 - p) ** (n - x)


def probs_samesame(N: int, m: int, min_successes: int = 2, num_rolls: int = 5) -> float:
    """
    N: number of trials
    m: number of possible outcomes
    min_successes: minimum number of successes required
    num_rolls: number of rolls
    """
    total: float = 0.0
    probs = probs_same(N, m)

    for i in range(N):
        if i < min_successes:
            continue
        total += binomial_distribution_mass(i, num_rolls, probs)

    return total


def binomial_average(n: int, p: float) -> float:
    """
    Calculates the average of a binomial distribution.

    :param n: number of trials
    :param p: probability of success
    :return: average of the binomial distribution
    """
    return n * p


def binomial_variance(n: int, p: float) -> float:
    """
    Calculates the variance of a binomial distribution.

    :param n: number of trials
    :param p: probability of success
    :return: variance of the binomial distribution
    """

    return n * p * (1 - p)


def coin_machine():
    print("If the machine has 3 wheels with 8 possible outcomes each:")
    print(f"    Probability of having all the same: {probs_same(3, 8)}")
    print(f"    Probability of having all different: {probs_different(3, 8)}")
    print(f"    Probability of at least 2 successes in 5 rolls: {probs_samesame(3, 8)}")
    print(
        f"    average of at least 2 successes in 5 rolls: {binomial_average(5, probs_same(3, 8))}"
    )
    print(
        f"    Variance of at least 2 successes in 5 rolls: {binomial_variance(5, probs_same(3, 8))}"
    )
    print("If the machine has 3 wheels with 8 possible outcomes each:")
    print(f"    Probability of having all the same: {probs_same(4, 5)}")
    print(f"    Probability of having all different: {probs_different(4, 5)}")
    print(f"    Probability of at least 2 successes in 5 rolls: {probs_samesame(4, 5)}")
    print(
        f"    average of at least 2 successes in 5 rolls: {binomial_average(5, probs_same(4, 5))}"
    )
    print(
        f"    Variance of at least 2 successes in 5 rolls: {binomial_variance(5, probs_same(4, 5))}"
    )


class target:
    def __init__(
        self,
    ):
        self.center: tuple[float, float] = (0, 0)
        self.radius: float = 0.1

    def distance(self, point: tuple[float, float]) -> float:
        return (
            (point[0] - self.center[0]) ** 2 + (point[1] - self.center[1]) ** 2
        ) ** 0.5

    def contains(self, point: tuple[float, float]) -> bool:
        return self.distance(point) <= self.radius


def gen_points(
    sigma: tuple[float, float], mu: tuple[float, float], n: int
) -> list[tuple[float, float]]:
    xpoints = np.random.normal(mu[0], sigma[0], n)
    ypoints = np.random.normal(mu[1], sigma[1], n)

    return list(zip(xpoints, ypoints))


def flechettes():
    print("Testing flechette's probability with monte carlo")
    tar = target()

    sigma_x: float = 0.1  # écart-type
    mu_x: float = 0.0  # moyenne
    mu_y: float = 0.0  # moyenne
    n = 10000

    print(f"n = {n}")

    # z < 1m: sigma_y = 0.05
    print("z < 1m: sigma_y = 0.05")

    sigma_y: float = 0.05  # écart-type

    points = gen_points((sigma_x, sigma_y), (mu_x, mu_y), n)
    hits = sum(tar.contains(point) for point in points)
    print(f"    Hits: {hits}")
    print(f"    Probability: {hits / n}")

    # z > 10m: sigma_y = 0.4
    print("z > 10m: sigma_y = 0.4")

    sigma_y = 0.4

    points = gen_points((sigma_x, sigma_y), (mu_x, mu_y), n)
    hits = sum(tar.contains(point) for point in points)
    print(f"    Hits: {hits}")
    print(f"    Probability: {hits / n}")


def p1():
    coin_machine()
    print()
    print()
    print()
    flechettes()


if __name__ == "__main__":
    p1()
