%
%
% fa -> Frequencia de Amostragem em Samples/seg
% Duration -> Duracao da aquisicao em segundos
% x -> vetor de dados
% time -> vetor de tempo
%
clear all;
delete(timerfindall);

fa = 400;
T=1/fa;
duration = 0.5;
% Setup da placa
s=daq.createSession('ni');
addAnalogInputChannel(s,'Dev1',0,'Voltage');   % Device 1 channel 0
s.Rate = fa;
s.DurationInSeconds = duration;
% Realiza a aquisicao
[x,time] = s.startForeground;


% Procura um valor de x tal que haja uma transicao de valor negativo (ou zero)
% para um valor positivo
% Dessa forma o sinal tera fase Phi = 0 ou aproximadamente 0
% N = dimensao do array x
[N,dummy]=size(x);
for i=2:N-1
    if x(i) <= 0 &  x(i+1) > 0  % deteccao da passagem por zero
       start = i+1;               % novo vetor deve iniciar com x(start+1)
       break
    end
end
start
x=x(start:N);           % readequacao do array x
                        % x deve ser um sinal com Phi = 0
N=length(x);            % novo valor de N
t=linspace(0,(N-1)*T,N); % novo array de tempo t
                        % t == time ????

% nome do arquivo aonde sera salvo os dados do array x
nomearquivo = 'teste.txt';                        
fileID = fopen(nomearquivo,'w');
for i=1:N 
    fprintf(fileID,"%4.2f\n",x(i));
end
plot(t,x);
xlabel('Tempo (seg)');
ylabel('Tensao');
