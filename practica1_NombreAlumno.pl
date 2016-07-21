%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Funciones Auxiliares - Parte I         %
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Parte I                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%       Funciones Auxiliares - Parte II        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% devuelvePAr/2: Relacion que nos da el valor 
% de la tupla par
devuelvePar(par(X,Y),X,Y).

% equal/2: Relacion que es cierta si X es igual a Y
equal(0,0) :- nat(0).
equal(s(X),s(Y)) :- equal(X,Y).

% nat/1: Relacion que define los numeros naturales
nat(0).
nat(s(X)) :- nat(X).

% esPar/3: Relacion que verifica si el primer argumento
% es un numero par y devuelve su valor en Z. Si el numero
% es impar en Z se devuelve un 0.
esPar(0,X,Z):- plus(0,X,Z).
esPar(s(0),X,Z):- plus(0,0,Z).
esPar(s(s(Y)),X,Z) :- esPar(Y,s(s(X)),Z).

% plus/3: Relacion que dado un X y un Y realiza la 
% suma y lo devuelve en Z
plus(0,X,X) :- nat(X). 
plus(s(X),Y,s(Z)) :- plus(X,Y,Z).

% times/3: Relacion que dado un X y un Y realiza la
% multiplicacion y lo devuelve en Z
times(X,s(0),X).
times(X,s(Y),Z) :-
	times(X,Y,Z1),
	plus(X,Z1,Z).

% tree/3: Definicion de un arbol
tree(Element,Left,Right).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Parte II.I                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
% arbolBalanceadoPar/1: Relación que verifica si dado 
% un arbol binario la suma de los pesos pares de su 
% arbol izquierdo es igual a la suma de los pesos pares 
% de su arbol derecho.	
arbolBalanceadoPar(tree(Element,Left,Right)) :-
	devuelvePar(Element,_,X),
	plus(0,X,X),
	recorrerSubArbol(Left,X,Zl),
	recorrerSubArbol(Right,X,Zr),
	equal(Zl,Zr).

% recorrerSubArbol/3: Relacion que recorre un arbol de
% manera que empieza por la raiz y realiza una llamada
% recursiva a los dos subarboles que tiene.
recorrerSubArbol(void,Y,Z) :-
	plus(0,Y,Z).

recorrerSubArbol(tree(Element,Left,Right),Y,Z) :-
	devuelvePar(Element,_,X),
	esPar(X,X,Xs),
	plus(Xs,Y,Zi),
	recorrerSubArbol(Left,Zi,Zl),
	recorrerSubArbol(Right,Zl,Z).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Parte II.II                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% arbolAmplificado/2: Relacion que verifica si dado un arbol 
% binario origen (primer argumento) el arbol binario amplificado 
% (segundo argumento) es igual que el origen salvo en los nodos 
% hoja en los que el peso se ha incrementado, con respecto al peso 
% original, en el numero de veces que indica la raiz del arbol origen.

% Caso en el que la raiz tiene los dos hijos
arbolAmplificado(tree(Element,Left,Right),AAmp) :-
	devuelvePar(Element,_,X),
	recorrerSubArbolAmpl(Left,X,Zl),
	recorrerSubArbolAmpl(Right,X,Zr),
	AAmp = tree(Element,Zl,Zr).

% Caso en el que la raiz tiene solo un hijo izquierdo
arbolAmplificado(tree(Element,Left,void),AAmp) :-
	devuelvePar(Element,_,X),
	recorrerSubArbolAmpl(Left,X,Zl),
	recorrerSubArbolAmpl(tree(void,void,void),X,Zr),
	AAmp = tree(Element,Zl,Zr).

% Caso en el que la raiz tiene solo un hijo derecho
arbolAmplificado(tree(Element,void,Right),AAmp) :-
	devuelvePar(Element,_,X),
	recorrerSubArbolAmpl(tree(void,void,void),X,Zl),
	recorrerSubArbolAmpl(Right,X,Zr),
	AAmp = tree(Element,Zl,Zr).

% recorrerSubArbolAmpl/3: Metodo que recorre un subarbol y
% le aplica el incremento de la raiz principal si es
% un nodo hoja del arbol
recorrerSubArbolAmpl(tree(void,void,void),X,AAmp) :-
	AAmp = void.

recorrerSubArbolAmpl(tree(Element,void,void),X,AAmp) :-
	devuelvePar(Element,ID,E),
	times(X,E,Ef),
	devuelvePar(NewElement,ID,Ef),
	AAmp = tree(NewElement,void,void).

recorrerSubArbolAmpl(tree(Element,Left,Right),X,AAmp) :-
	recorrerSubArbolAmpl(Left,X,Zl),
	recorrerSubArbolAmpl(Right,X,Zr),
	AAmp = tree(Element,Zl,Zr).
