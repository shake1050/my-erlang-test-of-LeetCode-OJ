%%%-------------------------------------------------------------------
%%% @author mobis010
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 一月 2015 16:41
%%%-------------------------------------------------------------------

%% The demons had captured the princess (P) and imprisoned her in the bottom-right corner of a dungeon. The dungeon consists of M x N rooms laid out in a 2D grid. Our valiant knight (K) was initially positioned in the top-left room and must fight his way through the dungeon to rescue the princess.
%%
%% The knight has an initial health point represented by a positive integer. If at any point his health point drops to 0 or below, he dies immediately.
%%
%% Some of the rooms are guarded by demons, so the knight loses health (negative integers) upon entering these rooms; other rooms are either empty (0's) or contain magic orbs that increase the knight's health (positive integers).
%%
%% In order to reach the princess as quickly as possible, the knight decides to move only rightward or downward in each step.
%%
%%
%% Write a function to determine the knight's minimum initial health so that he is able to rescue the princess.
%%
%% For example, given the dungeon below, the initial health of the knight must be at least 7 if he follows the optimal path RIGHT-> RIGHT -> DOWN -> DOWN.
%%
%% -2 (K)	-3	3
%% -5	-10	1
%% 10	30	-5 (P)
%%
%% Notes:
%%
%% The knight's health has no upper bound.
%% Any room can contain threats or power-ups, even the first room the knight enters and the bottom-right room where the princess is imprisoned.

-module(dungeon_game).
-author("mobis010").

%% API
-export([randomarray/2, knight_initial_health/2, knight_step/3]).

%%
%% initial_health(Array)  ->
%%   if
%%     length(Array) = 1 ->
%%
%%     N > 1 ->
%%
%%   end.


knight_initial_health(R,C) ->
  Array = random_array(R,C),
  knight_step(Array,{R,C},{1,1}).

knight_step(Array, {R,C}, {R,C}) ->
  Position =R*C-1,
  V= array:get(Position,Array),
  case 1-V >=1 of
    true  -> 1-V;
    false -> 1
  end;
knight_step(Array, {R,C}, {PR,PC}) ->
  Position =R*PC-R+PR-1,
  V= array:get(Position,Array),
  Down  = knight_stepdown(Array,{R,C},{PR+1,PC}),
%%   io:format("Down of step-> ~p~n",[Down]),
  Right = knight_stepright(Array,{R,C},{PR,PC+1}),
%%   io:format("Right of step -> ~p~n",[Right]),
  case Down < Right of
    true ->
%%       io:format("step Down -> ~p~n",[Down]),
      case Down-V >=1 of
        true  -> Down-V;
        false -> 1
      end;
    false ->
%%       io:format("step Right -> ~p~n",[Right]),
      case Right-V >=1 of
        true  -> Right-V;
        false -> 1
      end
  end.

knight_stepright(Array, {R,C}, {PR,PC}) ->
  case PC>C of
    true -> knight_stepright(Array,{R,C},{PR+1,PC-1});
    false -> knight_step(Array,{R,C},{PR,PC})
  end.

knight_stepdown(Array,{R,C},{PR,PC}) ->
  case PR>R of
    true -> knight_stepright(Array,{R,C},{PR-1,PC+1});
    false -> knight_step(Array,{R,C},{PR,PC})
  end.


%% reversed array
random_array(_,0) -> [];
random_array(R,C) when is_integer(R) andalso is_integer(C)   andalso R>0  andalso C>0 ->
  [random_list(R,C)|random_array(R,C-1)].

%% reversed list
random_list(0,_)  -> [];
random_list(R,C) when is_integer(R) andalso is_integer(C)  andalso R>0  andalso C>0 ->
  [{C,R,(random:uniform(40)-20)} | random_list(R-1,C)].

%% real array
randomarray(0,Array) -> Array;
randomarray(N,Array) ->
  ArrayNew= array:set(N-1,random:uniform(40)-20,Array),
  randomarray(N-1,ArrayNew).
