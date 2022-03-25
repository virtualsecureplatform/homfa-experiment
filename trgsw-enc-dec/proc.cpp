#include <tfhe++.hpp>

using namespace TFHEpp;

void perform(const SecretKey &sk, std::vector<TRGSWFFT<lvl1param>> &cs) {
  Polynomial<lvl1param> poly = {};
  for (auto &&t : cs) {
    t = trgswfftSymEncrypt<lvl1param>(poly, lvl1param::α, sk.key.lvl1);
  }
}
