function cameFrom = aStar(theProblem)
    % create the start node
    node = theProblem.getStartStateIndx();

    frontier = PriorityQueue();
    frontier.push(node, 0);

    cameFrom = zeros(theProblem.dimension^2, 1);
    cameFrom(node) = node;

    costSoFar = inf(theProblem.dimension^2, 1);
    costSoFar(node) = 0;
    
    while ~frontier.isEmpty
        currentNode = frontier.pop();

        if theProblem.isGoalState(currentNode)
            disp('goal Found');
            return
        end

        childNodes = theProblem.getSuccessors(currentNode, 4);
        for i = 1:numel(childNodes)
            newCost = costSoFar(currentNode) + 1;
            if (costSoFar(childNodes(i)) == 0) || (newCost < costSoFar(childNodes(i)))
                costSoFar(childNodes(i)) = newCost;
                priority = newCost + theProblem.preCalculatedHeuristic(childNodes(i));
                cameFrom(childNodes(i)) = currentNode;
                frontier.push(childNodes(i), priority);               
            end
        end
    end
end