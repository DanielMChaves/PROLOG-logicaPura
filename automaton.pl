% Fichero que contiene las reglas

% regla/4 relacion que es cierta si se cumple si X, Y y Z
% pertenecen a una regla

regla(o,o,o,o). % ooo -> o
regla(x,o,o,x). % xoo -> x
regla(o,x,o,o). % oxo -> o
regla(o,o,x,x). % oox -> x
regla(x,o,x,x). % xox -> x
regla(x,x,o,x). % xxo -> x
regla(o,x,x,x). % oxx -> x
regla(x,x,x,o). % xxx -> o
