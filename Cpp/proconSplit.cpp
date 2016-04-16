#include <cstdlib>
#include <iostream>
#include <vector>


static std::vector<std::string>
split(const std::string& str, char delim);

static std::vector<std::string>
split(const std::string& str, const std::string &delim);


int
main()
{
  std::cin.tie(0);
  std::ios::sync_with_stdio(false);

  std::string line;
  while (std::getline(std::cin, line)) {
    std::cout << line << std::endl;
    std::vector<std::string> tokens = split(line, ',');
    <+CURSOR+>
  }

  return EXIT_SUCCESS;
}


static std::vector<std::string>
split(const std::string& str, char delim)
{
  std::vector<std::string> tokens;
  std::string::size_type spos = 0, epos;
  while ((epos = str.find_first_of(delim, spos)) != std::string::npos) {
    tokens.push_back(std::string(str, spos, epos - spos));
    spos = epos + 1;
  }
  tokens.push_back(std::string(str, spos, str.size() - spos));
  return tokens;
}


static std::vector<std::string>
split(const std::string& str, const std::string &delim)
{
  std::vector<std::string> tokens;
  std::string::size_type spos = 0, epos, delimlen = delim.size();
  while ((epos = str.find(delim, spos)) != std::string::npos) {
    tokens.push_back(std::string(str, spos, epos - spos));
    spos = epos + delimlen;
  }
  tokens.push_back(std::string(str, spos, str.size() - spos));
  return tokens;
}