function adda(Fa,Duration)
% necessario deletar todos os timers ativos
delete(timerfindall)
Fa = 200;         % Sampling frequency
Ta = 1/Fa;        % Sampling time
Duration = 60;    % Duracao em segundos
NumberOfTasksToExecute = round(Duration/Ta);

% setup da placa
s=daq.createSession('ni');
addAnalogInputChannel(s,'Dev1',0,'Voltage');
addAnalogOutputChannel(s,'Dev1',0,'Voltage');
s.Rate=Fa
%s.startForeground

% Create and configure timer object
tm = timer('ExecutionMode','fixedRate', ...            % Run continuously
    'Period',Ta, ...                                   % Period = sampling time
    'TasksToExecute',NumberOfTasksToExecute, ...       % Runs NumberOfTasksToExecute times
    'TimerFcn',@MyTimerFcn, ...                        % Run MyTimerFcn at each timer event
    'StopFcn', @StopEverything);

start(tm)

function MyTimerFcn(obj,event)
  x=inputSingleScan(s);     % le o dado do canal de entrada 0
  outputSingleScan(s,x);    % escreve o dado no canal de saida 0    
end    
    
function StopEverything(obj,event)  
disp('Acabou !!!')
end

end    
