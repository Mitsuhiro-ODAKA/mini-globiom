*-------------------------------------------------------------------------------
* Title: Simple Agricultural Sector Model (GLOBIOM-like basic structure)
* Author: Mitsuhiro Odaka
* Date: 2025-05-14
* Description: A simple model to maximize profit from crop production
* under a land constraint.
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
* 1. Set Declarations
*-------------------------------------------------------------------------------
Sets
    i   'Crops'         / rice  "Rice"
                          wheat "Wheat" /

    j   'Regions'       / region1 "Single Region" /;

*-------------------------------------------------------------------------------
* 2. Data Declarations and Definitions (Parameters)
*-------------------------------------------------------------------------------
Parameters
    market_price(i)      'Market price of crop i (USD/ton)'
                         / rice   400
                           wheat  250 /

    yield_per_ha(i,j)    'Yield of crop i in region j (ton/ha)'
                         / rice.region1   5
                           wheat.region1  3 /

    cost_per_ha(i,j)     'Production cost of crop i in region j (USD/ha)'
                         / rice.region1   800
                           wheat.region1  400 /

    land_available(j)    'Available agricultural land in region j (ha)'
                         / region1  100 /;

* Scalars for demonstration (can be derived if needed)
Scalar  total_land_available 'Total available land across all regions (ha)';
total_land_available = sum(j, land_available(j));


*-------------------------------------------------------------------------------
* 3. Variable Declarations
*-------------------------------------------------------------------------------
Variables
    X(i,j)               'Area cultivated for crop i in region j (ha)'
    Production(i,j)      'Production of crop i in region j (ton)'
    TotalProfit          'Total profit from all crops and regions (USD)';

Positive Variables X, Production;

*-------------------------------------------------------------------------------
* 4. Equation Declarations
*-------------------------------------------------------------------------------
Equations
    Eq_Objective         'Objective function: maximize total profit'
    Eq_ProductionDef(i,j)'Production definition for crop i in region j'
    Eq_LandConstraint(j) 'Land use constraint for region j';

*-------------------------------------------------------------------------------
* 5. Equation Definitions
*-------------------------------------------------------------------------------

* Objective Function: Maximize total profit
Eq_Objective..
    TotalProfit =E= sum((i,j), market_price(i) * Production(i,j) - cost_per_ha(i,j) * X(i,j) );

* Production Definition: Production = Area * Yield
Eq_ProductionDef(i,j)..
    Production(i,j) =E= X(i,j) * yield_per_ha(i,j);

* Land Constraint: Total cultivated area must be less than or equal to available land
Eq_LandConstraint(j)..
    sum(i, X(i,j)) =L= land_available(j);

*-------------------------------------------------------------------------------
* 6. Model Definition and Solve Statement
*-------------------------------------------------------------------------------
Model SimpleFarmModel /
    Eq_Objective
    Eq_ProductionDef
    Eq_LandConstraint
/;

Solve SimpleFarmModel using LP maximizing TotalProfit;

*-------------------------------------------------------------------------------
* 7. Displaying Results
*-------------------------------------------------------------------------------
Display X.l, X.m,          
        Production.l,    
        TotalProfit.l;  

* Optional: More detailed reporting
Parameter report(i,j,*) 'Detailed report';
report(i,j,'Area_ha') = X.l(i,j);
report(i,j,'Yield_ton_ha') = yield_per_ha(i,j);
report(i,j,'Production_ton') = Production.l(i,j);
report(i,j,'Price_usd_ton') = market_price(i);
report(i,j,'Cost_usd_ha') = cost_per_ha(i,j);
report(i,j,'Revenue_usd') = market_price(i) * Production.l(i,j);
report(i,j,'TotalCost_usd') = cost_per_ha(i,j) * X.l(i,j);
report(i,j,'Profit_usd') = market_price(i) * Production.l(i,j) - cost_per_ha(i,j) * X.l(i,j);

Display report;

* Check the marginal value of the land constraint
Display Eq_LandConstraint.m;
* This tells how much the total profit would increase if one more unit of land became available.

* End of GAMS code