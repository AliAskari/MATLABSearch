classdef searchProblem < handle
	
	properties
		gridX				%Matrix containing position of nodes along X axis
		gridY				%Matrix containing position of nodes along Y axis
        dimension			%Dimension of the grid

		workSpace			%Matrix showing the state of a node; i.e. free, wall, goal, start
		freeSpace			%Column vector containing the "index" of freenodes from the grid
		wallSpace			%Column vector containing the "index" of occupied nodes from the grid

		startState			%Vector containing the X, Y position of start node
		goalState			%Vector containing the X, Y position of goal node

		startStateIndx 		%Index of start node
		goalStateIndx		%Index of goal node

		preCalculatedHeuristic		 
    end

	methods
		function theProblem = searchProblem(dimension)
			% Create a (dimension X dimension) grid 
			% and then create a matrix, grid, containg the coordinate of all nodes
            theProblem.dimension = dimension;
			[theProblem.gridX, theProblem.gridY] = meshgrid(1:theProblem.dimension);
			grid = [theProblem.gridX(:), theProblem.gridY(:)];

			% create the workSpace and initilize all nodes as free
			% freeSpace is 0
			% wallSpace is 1
			% startState is 2
			% goalState is 3			
			theProblem.workSpace = zeros(dimension); 

			% Grid boundaries are walls
			theProblem.workSpace(dimension, :) = 1;
			theProblem.workSpace(:, dimension) = 1;

			% walls/obstacles in workspace
			theProblem.workSpace(3, 3:13) = 1 ;
			theProblem.workSpace(3:13, 13) = 1;
			theProblem.workSpace(13, 6:13) = 1;


			%Coordinate of goal and start states
			theProblem.startState = [1, 1];	
			theProblem.goalState = [14, 14];

			%Get the index of goal and start state
			[~, indxSS] = min(sum(abs(bsxfun(@minus, grid, theProblem.startState)), 2));
			[~, indxGS] = min(sum(abs(bsxfun(@minus, grid, theProblem.goalState)), 2));

			theProblem.startStateIndx = indxSS;
			theProblem.goalStateIndx = indxGS;

			%Change the state of free nodes to goal/start
			theProblem.workSpace(indxSS) = 2;
			theProblem.workSpace(indxGS) = 3;


			%Get the "index" of free/occupied nodes from the grid 
			theProblem.wallSpace = find(theProblem.workSpace == 1);
			theProblem.freeSpace = find(theProblem.workSpace == 0);


			%% Calcuate the heuristic for search
			%Manhattan
% 			theProblem.preCalculatedHeuristic = (sum(abs(bsxfun(@minus, grid, theProblem.goalState)), 2));

			%Euclidean
			theProblem.preCalculatedHeuristic = sqrt(sum(bsxfun(@minus, grid, theProblem.goalState).^2, 2));
		end

		function startStateIndx = getStartStateIndx(theProblem)
			startStateIndx = theProblem.startStateIndx;
		end

		function isGoal = isGoalState(theProblem, agentStateIndx)
			isGoal = (agentStateIndx == theProblem.goalStateIndx);
		end

		function successors = getSuccessors(theProblem, currentNodeIndx, neighbours)
			% returns the 4/8 neigbours of each node 
			% the order of neighbours is ClockWise:
			%			   (1)Up
			%	(8)UpLeft		   (2)UpRight
			%	(7)Left			   (3)Right
			%	(6)DownLeft		   (4)DownRight
			%			   (5)Down
			%Read here to know why I did this:http://blogs.mathworks.com/loren/2010/11/12/meet-the-neighbors/

			if neighbours == 4
				delta = [ 1;  theProblem.dimension; 
						 -1; -theProblem.dimension;];

			elseif neighbours == 8
				delta = [1;
						 1+theProblem.dimension;
						 theProblem.dimension; 
						 -1+theProblem.dimension; 
						 -1; 
						 -1-theProblem.dimension;
						 -theProblem.dimension;
						 1-theProblem.dimension];
			end

			% Create the successor matrix and check if all neighbours are within the grid/freeSpace
			% if not don't add them to the successors matrix
			successors = zeros(neighbours, 1);

			for i=1:neighbours
				childIndx = delta(i) + currentNodeIndx;
				if (childIndx > 0) & ((childIndx < theProblem.dimension^2) + 1)
					if ~(theProblem.workSpace(childIndx) == 1) % if the index is not in the wallSpace it is in the freeSpace!
						successors(i) = childIndx;
					end
				end
			end
			successors(successors == 0) = [];
		end


		function plotProblem(theProblem)
            close all
            figure()
			SS = theProblem.startState;
			GS = theProblem.goalState;
            cmap = [1, 1, 1;	%freeSpace (white)(0)
                    0, 0, 0;	%wallSpace (black)(1)
                    1, 0, 0; 	%startState (red)(2)
                    0, 1, 0]; 	%goalState (blue)(3)

			pcolor(theProblem.gridX, theProblem.gridY, theProblem.workSpace);
            ax = gca;
			[N,M] = size(theProblem.gridX);
			set(ax,'XTick',0.5+1:2:N)
			set(ax,'XTickLabel',1:2:N)
			set(ax,'YTick',0.5+1:2:M)
			set(ax,'YTickLabel',1:2:M)
            axis square
			colormap(cmap);  
		end

	end

end