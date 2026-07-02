-- by DeepLogic

-- Trade Route duration: minimal > 12 (was 20), do not increase based on Era.
update GlobalParameters set Value = 12 where Name = 'TRADE_ROUTE_TURN_DURATION_BASE';

-- The minimal duration is increased depending on the world era. Make it not increased.
update Eras_XP2 set TradeRouteMinimumEndTurnChange = 0;
