classdef searchAgent < handle

	properties
		searchProblem
		searchFunction

		startState
		currentState
	end


	methods

		function theAgent = searchAgent(theProblem)
			theAgent.searchProblem = theProblem;
			theAgent.startState = theProblem.startState;
			theAgent.currentState = theProblem.startState;
		end

		function plotPath(theAgent, path, visitedNodes)
			indxSS = theAgent.searchProblem.startStateIndx;
			indxGS = theAgent.searchProblem.goalStateIndx;

			[visitedIndx, ~] = find(visitedNodes ~= 0);
			theAgent.searchProblem.workSpace(visitedIndx) = 5;
			theAgent.searchProblem.workSpace(path) = 4;
			theAgent.searchProblem.workSpace(indxSS) = 2;
			theAgent.searchProblem.workSpace(indxGS) = 3;

			figure()
            cmap = [1, 1, 1;	%freeSpace (white)
                    0, 0, 0;	%wallSpace (black)
                    0.92, 0.29, 0.38; 	%startState (red)
                    0.3, 0.53, 0.86; 	%goalState (blue)                    
                    0.21, 0.73, 0.52;	%path (green)
                    0.5, 0.5, 0.5]; %visited

			pcolor(theAgent.searchProblem.gridX, theAgent.searchProblem.gridY, theAgent.searchProblem.workSpace);
			ax = gca;
			[nRow, nCol] = size(theAgent.searchProblem.gridX);
			set(ax,'XTick',0.5+1:2:nRow)
			set(ax,'XTickLabel',1:2:nRow)
			set(ax,'YTick',0.5+1:2:nCol)
			set(ax,'YTickLabel',1:2:nCol)

            axis square
			colormap(cmap); 


		end
	end
end
