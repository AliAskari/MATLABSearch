function cameFrom = greedy(theProblem)

    % create the start node
    node = theProblem.getStartStateIndx();

    frontier = PriorityQueue();
    frontier.push(node, 0);

    cameFrom = zeros(theProblem.dimension^2, 1);
    cameFrom(node) = node;
    
    while ~frontier.isEmpty
        currentNode = frontier.pop();

        if theProblem.isGoalState(currentNode)
            disp('goal Found')
            return
        end

        childNodes = theProblem.getSuccessors(currentNode, 4);
        for i = 1:numel(childNodes)
            if cameFrom(childNodes(i)) == 0
                priority = theProblem.preCalculatedHeuristic(childNodes(i));
                frontier.push(childNodes(i), priority);               
                cameFrom(childNodes(i)) = currentNode;
            end
        end
    end
end