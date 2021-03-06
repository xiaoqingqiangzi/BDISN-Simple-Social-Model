%          Simple Agent Model           Assignment Week 3
%          Sander Martijn Kerkdijk      Max Turpijn
%          Course: Behaviour Dynamics in social Networks 
%               Vrije Universiteit Amsterdam 2015
%                   Copying will be punished

% INITIALIZATION

% Prompt for variables
prompt = {'Enter Number Of Agents:','Enter Steps:','Enter Update:','Enter stepsize (delta_t):','Enter chance on no connection between agents:'};
dlg_title = 'Simple Agent Model';
num_lines = 1;
defaultans = {'5','100','0.5','0.1','0.1'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

% global start time 
start_time = 1;

% number of agents
number_agents = str2double(answer(1));

% global end time 
steps = str2double(answer(2));  

% update
update = str2double(answer(3));

% step size
delta_t = str2double(answer(4)); 

% chance of no connection between two agents
chanceZero = str2double(answer(5));

% make a random vector for states
state = zeros(number_agents,steps); 


% INITIALIZE RANDOM FIRST VARIABLES FOR AGENTS.

for agents = 1:number_agents
    state(agents,1) = rand(1);
end

% initialize AGGIMPACT

aggimpact = double(number_agents);


% CREATE VARIABLE CONTAINING CONNECTION WEIGHTS FOR THE CONNECTIONS BETWEEN AGENTS

% calculating chance by given a percentage more than zero
chanceRest = (1-chanceZero)/9; 

% make a vector with random numbers given by number of agents
r=rand(number_agents); 

% make probability vector
prob=[chanceZero,chanceRest,chanceRest,chanceRest,chanceRest,chanceRest,chanceRest,chanceRest,chanceRest,chanceRest,chanceRest];
prob = cumsum(prob);

% values corresponding to the probabilities
value=[0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1];   

% calculate weights
weights = arrayfun(@(z)(value(find(z<=prob,1,'first'))), r);

% remove reflexive values
for agents = 1:number_agents
    weights(agents,agents) = 0;
end


% MAKING THE SCALE VECTOR

scalevector = sum(weights,2);
  

%CALCULATING STATES OF AGENTS


% initializing time
time = start_time + delta_t;

%initializing step
stateNumber = 2;
intermediate_state = zeros(number_agents);

for agents = 1:number_agents
intermediate_state(agents) = state(agents,1);
end

% While the starttime is not the given steps.
while start_time < steps 
    step = 1;

    while step <= 10 
        start_time = start_time + delta_t;
   
     % calculate AGGIMPACT
    for agent = 1:number_agents
        ssum = 0;
        aggimpact(agent) = 0;
        
        % calculate SUM
         for agents = 1:number_agents
            ssum = ssum + ((weights(agent,agents)*(intermediate_state(agents))));  
         end
         
        % add find sum to given agent by aggimpact(t) + (SSUM/ScaledVector)
        aggimpact(agent) = aggimpact(agent) +((ssum)/scalevector(agent)); 
    end 
    
        for agents = 1:number_agents
            % update rule state(t+delta_t) = state(t)(update(aggimpact(choosen agent)delta_t
            % applying the update rule
            intermediate_state(agents) = intermediate_state(agents) + (update*((aggimpact(agents) - intermediate_state(agents))*delta_t));    
        end
        
        % next step
        step = step + 1;
    end
    
    for agents = 1:number_agents
        % When the state of a agent is bigger than 1,make the state 1.
        if intermediate_state(agents) > 1
            intermediate_state(agents) = 1;
        end
     
         state(agents,stateNumber) = intermediate_state(agents);
    end
    
    % next state
    stateNumber = stateNumber + 1;
end

% MAKE A PLOT

% make a output Variable
output = zeros(number_agents,steps);

% make for every agent another color for the plot
cmap = hsv(number_agents);

% Setting Stepsize for every point on plot
x = 0:1:steps-1;

% convert given states to an output
for i=1:number_agents
    for t = 1:steps
    eval(sprintf('output_a%d(%d) = state(%d,%d)', i,t,i,t));
    end
end

% finally plot
hold on;
for output= 1:number_agents
    subplot(round(number_agents/4)+1,4,output);
    % Plot a output with a given color
    eval(sprintf('plot(x,output_a%d,''-s'',''Color'',cmap(output,:))',output)); 
   
    % set range of plot
    axis([0 inf 0 1])
    
    % set title to plot
    eval(sprintf('title(''Agent %d'')',output));
end
hold off;

