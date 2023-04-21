" abbrevtation for cpp, cc

iabbrev speed std::ios_base::sync_with_stdio(false);<CR>std::cin.tie(0);<CR>std::cout.tie(0);<CR>

iabbrev ialgo #include <iostream>
        \<CR>#include <vector>
        \<CR>#include <algorithm>
        \<CR>#include <string>
        \<CR>#include <sstream>
        \<CR>#include <queue>
        \<CR>#include <deque>
        \<CR>#include <unordered_map>
        \<CR>#include <iterator>
        \<CR>#include <bitset>
        \<CR>#include <iterator>
        \<CR>#include <list>
        \<CR>#include <stack>
        \<CR>#include <map>
        \<CR>#include <set>
        \<CR>#include <functional>
        \<CR>#include <numeric>
        \<CR>#include <utility>
        \<CR>#include <limits>
        \<CR>#include <time.h>
        \<CR>#include <math.h>
        \<CR>#include <stdio.h>
        \<CR>#include <string.h>
        \<CR>#include <stdlib.h>
        \<CR>#include <assert.h>
        \<CR>#include <chrono>
        \<CR>#include <limits.h><CR>


iabbrev <silent> #i #include ""<Left><C-R>=EatChar('\s')<CR>
iabbrev <silent> #I #include <><Left><C-R>=EatChar('\s')<CR>
iabbrev inio #include <iostream><CR>
iabbrev invt #include <vector><CR>
iabbrev #d #define<Right>
iabbrev im int main(int argc, char **argv)<CR>{<CR>return 0;}<Up><Up><CR>
iabbrev ifelse if ()<CR>{<CR>}<CR>else<CR>{<CR><C-O>?}<CR>
iabbrev stdstr std::string
iabbrev switch switch ()<CR>{<CR>default:<CR>break;}
iabbrev <silent> fori for(int i = 0; i < count; ++i)<CR>{}<Up>
iabbrev <silent> forj for(int j = 0; j < count; ++j)<CR>{}<Up>
iabbrev <silent> fora for(auto x: container)<Left>
iabbrev <silent> forit for(iterator it = .begin(); < .end(); ++it)<CR>{<CR>}

iabbrev defmod constexpr int mod = 1e9+7;
iabbrev begintime std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();
iabbrev endtime std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();
            \<CR>std::cout << "run time: " << std::chrono::duration_cast<std::chrono::microseconds>(end-begin).count() << "ms" << std::endl;<CR>

iabbrev benchmark template<typename F, typename... Args>
            \<CR>void benchmark(std::string msg, F func, Args&& ...args) {
                \<CR>using std::chrono::high_resolution_clock;
                \<CR>using std::chrono::duration_cast;
                \<CR>using std::chrono::duration;
                \<CR>typedef std::chrono::high_resolution_clock::time_point TimeVar;
                \<CR>TimeVar beginTime = high_resolution_clock::now();
                \<CR>func(std::forward<Args>(args)...);
                \<CR>TimeVar endTime = high_resolution_clock::now();
                \<CR>std::cout << msg << "\t\t" << duration<double, std::milli>(endTime - beginTime).count() << "ms" << std::endl;
                \<CR>}<Esc>

iabbrev def #define
iabbrev debug #define DEBUG 1
iabbrev usestd using namespace std;
iabbrev intmain int main(int argc, char** argv)
            \<CR>{
                \<CR>
            \<CR>return 0;
            \}<Up><Up>

iabbrev <silent> fora for(auto e: ) {<CR>}<Up><Esc>4wa
iabbrev <silent> fori for(int i = 0; i < ; ++i) {<CR>}<Up><Esc>9wi
iabbrev <silent> foriter for(auto it = .begin(); it != .end(); ++it) {<CR>}<Up><Esc>5wi
iabbrev ll typedef long long ll;

iabbrev <silent>tc int T;<CR>std::cin >> T;<CR>

iabbrev fgcd long long gcd(long long a, long long b) {
            \<CR>while(b > 0) {
                \<CR>long long c = a/b;
                \<CR>a = b;
                \<CR>b = c;
                \}
                \<CR>return a;
                \}

iabbrev flcm long long lcm(long long a, long long b) {
            \<CR>return a*b/gcd(a,b);
            \}

iabbrev fsieve void init_sieve(int n) {
            \<CR>std::vector<bool> is_prime(n, true);
            \<CR>is_prime[0] = is_prime[1] = false;
            \<CR>for(int i = 2;i < n; ++i) {
                \<CR>if(is_prime[i] && i*i < n) {
                    \<CR>for(int j = i; j < n; j+= i) {
                        \<CR>is_prime[j] = false;
                        \}
                        \}
                        \}
            \}

iabbrev tcase int T;
            \<CR>std::cin >> T;
            \<CR>while (T--) {
                \<CR>}

" cmake template
"iabbrev cmakerun cmake_minimum_required(VERSION 3.8.2)
"            \<CR># project name
"            \<CR>project(PROJECT_NAME VERSION 0.1)
"            \<CR>set(CMAKE_CXX_STANDARD 11)
"            \<CR>set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
"            \<CR>add_executable()
"            \<CR>add_library()
"            \<CR>add_subdirectory()
"            \<CR>target_include_directories()
"            \<CR>include_directories()
"            \<CR>target_link_directories()
"
" cpp utils functions
