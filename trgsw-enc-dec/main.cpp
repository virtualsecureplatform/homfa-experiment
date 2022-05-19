#include <chrono>
#include <tfhe++.hpp>

using namespace TFHEpp;

const size_t NUM_TEST = 1000;

void perform(const SecretKey &sk, std::vector<TRGSWFFT<lvl1param>> &cs, std::vector<double> &elapsed);

int main() {
  std::unique_ptr<SecretKey> sk = std::make_unique<SecretKey>();
  std::vector<TRGSWFFT<lvl1param>> cs(NUM_TEST);
  std::vector<double> elapsed;

  perform(*sk, cs, elapsed);

  double elapsed_total = std::accumulate(elapsed.begin(), elapsed.end(), 0.0, [](double sum, double e) {
    std::cout << e << std::endl;
    return sum + e;
  });

  std::cout << "Total: " << elapsed_total << "(us)\n"
            << "Mean: " << elapsed_total / NUM_TEST << "(us)\n";
}
