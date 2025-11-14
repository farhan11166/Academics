% weather.pl
% Facts (atomic statements)
warm.
raining.
sunny.
pleasant.

% Rules (Prolog form from the English sentences)
enjoy :- sunny, warm.
strawberry_picking :- warm, pleasant.
not_strawberry_picking :- raining.
wet :- raining.

% (Optional) helper to show both strawberry_picking and its negation
contradiction_strawberry :-
    strawberry_picking,
    not_strawberry_picking.
