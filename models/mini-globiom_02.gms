SETS
  l  Land types /arable, forest/
  c  Crops      /wheat, maize/;

PARAMETERS
  land_avail(l)
  price(c)
  yield(c)
  co2_emission(l,c)
  cost(c);

land_avail("arable") = 100;
land_avail("forest") = 50;

price("wheat") = 300;
price("maize") = 250;

yield("wheat") = 2.5;
yield("maize") = 3.0;

cost("wheat") = 100;
cost("maize") = 90;

co2_emission("arable","wheat") = 0.5;
co2_emission("arable","maize") = 0.6;
co2_emission("forest","wheat") = 2.0;
co2_emission("forest","maize") = 2.2;

VARIABLES
  land_use(l,c)
  profit
  total_emission;

POSITIVE VARIABLES land_use;

EQUATIONS
  profit_def
  land_constraint(l)
  emission_def;

profit_def.. 
  profit =E= SUM((l,c), (price(c)*yield(c) - cost(c)) * land_use(l,c));

land_constraint(l).. 
  SUM(c, land_use(l,c)) =L= land_avail(l);

emission_def..
  total_emission =E= SUM((l,c), co2_emission(l,c)*land_use(l,c));

MODEL maximize_profit /all/;
SOLVE maximize_profit USING LP MAXIMIZING profit;

DISPLAY land_use.l, profit.l, total_emission.l;
