#include <tfhe++.hpp>
#include <chrono>

using namespace TFHEpp;

void perform(const SecretKey &sk, std::vector<TRGSWFFT<lvl1param>> &cs, std::vector<double> &elapsed) {
  Polynomial<lvl1param> poly = {};
  for (auto &&t : cs) {
    std::chrono::system_clock::time_point start = chrono::system_clock::now();
    t = trgswfftSymEncrypt<lvl1param>(poly, lvl1param::α, sk.key.lvl1);
    std::chrono::system_clock::time_point end = chrono::system_clock::now();

    double e = duration_cast<std::chrono::microseconds>(end - start).count();
    elapsed.push_back(e);
  }
}
