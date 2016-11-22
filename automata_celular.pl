% Cargamos el fichero de las reglas
:- ensure_loaded(automaton).

% cells/2: Metodo que le pasas una lista que contiene
% o y x y te devuelve una lista en la que se amplican
% las reglas que estan en el fichero automaton.pl
cells(Xs,Y) :-
	dos(Xs,Y),
	suffix([x,o],Xs),
	preffix([o,x],Xs),
	myappend([o],Ys,Y),
	aux1([o|Xs],Ys).

% aux1/2: Metodo recursivo que recorre la lista
% amplicando las reglas del fichero automaton.pl
aux1([A,B,C|Xs],Y) :-
	regla(A,B,C,F),
	myappend([F],Ys,Y),
	aux1([B,C|Xs],Ys).

% aux1/2: Metodo que aplica la regla para el final
% de la lista
aux1([x,o],Y) :-
	regla(x,o,o,F),
	myappend([F],[o],Y).

% dos/2 y doss/2: sirven para realizar un corte implícito.
% Esto permite que no se quede el programa en bucle cuando
% es la Y la que está instanciada.
dos(Xs,[o|Ys]) :- doss(Xs,Ys).

doss([],[o]).
doss([_|Xs],[_|Ys]):- doss(Xs,Ys).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Funciones Auxiliares             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% prefix/2: Relacion que es cierta si la lista del
% primer argumento es prefijo de la lista del
% segundo argumento
preffix([],_).
preffix([X|Xs],[X|Ys]) :- preffix(Xs,Ys).

% suffix/2: Relacion que es cierta si la lista del
% primer argumento es sufijo de la lista del
% segundo argumento
suffix(Xs,Xs).
suffix(Xs,[_|Ys]) :- suffix(Xs,Ys).

% myappend/3: Relacion que introduce el elemento X
% en la lista del segundo parametro
myappend([],L2,L2).
myappend([X|Xs],L2,[X|R]):- myappend(Xs,L2,R).
