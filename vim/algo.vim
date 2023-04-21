iabbrev BinarySearch while(low < high)
            \<CR>{
            \<CR>int mid = low + (high - low) / 2;
            \<CR>if ([condition])
            \<CR>{
            \<CR> high = mid + 1;
            \<CR>}
            \<CR>else {
            \<CR>low = mid;
            \<CR>}
            \<CR>}

iabbrev BFS std::queue<int> q;
            \<CR>q.push(startVertex);
            \<CR>visited[startVertex] = true;
            \<CR>while(!q.empty()) {
                \<CR>int curr = q.front();
                \<CR>q.pop();
                \<CR>for(auto v: adj[curr]) {
                    \<CR>if(!visited[v])
                    \<CR>{
                        \<CR>visited[v] = true;
                        \<CR>q.push(v);
                    \<CR>}
                \<CR>}
            \<CR>}
