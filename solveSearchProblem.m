clear all; clc

% To read more about the search algorithms go here: http://www.redblobgames.com/pathfinding/a-star/introduction.html


tic
aSearchProblem = searchProblem(16);
% aSearchProblem.plotProblem();
toc



% cameFrom = dijkstra(aSearchProblem);
cameFrom = greedy(aSearchProblem);
% cameFrom = aStar(aSearchProblem);

current = aSearchProblem.goalStateIndx;
path = current;

while current ~= aSearchProblem.startStateIndx
	current = cameFrom(current);
	path = [current; path];    
end
toc

searchAgent = searchAgent(aSearchProblem);
searchAgent.plotPath(path, cameFrom);



[~, visited] = find(cameFrom ~= 0);
fprintf('Number of free nodes: %d\n', numel(aSearchProblem.freeSpace));
fprintf('Number of visited nodes: %d\n', sum(visited));
