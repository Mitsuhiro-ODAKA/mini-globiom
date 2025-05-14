# Mini-GLOBIOM Land Use Optimization Models

Simplified GAMS models inspired by the GLOBIOM framework.

## Model 01
Profit maximization under single region, multiple crops, and land constraints

### Results
  - All 100 hectares of available farmland will be used for rice production and no wheat will be produced at all. This results in a total profit of $120,000.
  - If one more hectare of farmland is added, the total profit could increase by $1,200 (the shadow price, or marginal value, of the land use constraint).
  - Under current conditions, wheat is not produced because it would result in a loss of $850 per hectare.

## Model 02
Profit maximization under multiple regions (arable, forest), multiple crops (wheat, maize) and land constraints, while at the same time calculating total_emission.

### Results
  - To maximize profit, it is best to grow corn on all 100 available units of arable land and 50 units of forest land. No wheat is grown at all. The maximum profit in this case is 99,000. Total emissions will be 170.
  - If one additional unit of both arable and forest land were made available, the profit could each increase by 660 (marginal value of land).
  - Currently, wheat is not grown because growing wheat incurs an opportunity cost of 10 per unit.

## Future extension
  - Inter-regional transport 
  - Resource constraints (water, fertilizer, etc.) 
  - Dynamic analysis (multiple periods)

## How to Run
Open `mini-globiom_xx.gms` in GAMS Studio and execute.
