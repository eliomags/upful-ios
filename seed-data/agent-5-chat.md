# Chat Messages Seed Data

```sql
-- ============================================================
-- CHAT MESSAGES (100 rows)
-- Premium/Pro users only
-- IDs: g0000000000000000000000000000001 - g0000000000000000000000000000064
-- ============================================================

INSERT INTO chat_messages (id, user_id, username, content, image_key, tickers, is_deleted, created_at) VALUES
('g0000000000000000000000000000001', 'a000000000000000000000000000001', 'traderpro', 'Good morning everyone! Futures are looking solid, let''s get this bread', null, null, 0, '2024-02-05T09:15:22.000Z'),
('g0000000000000000000000000000002', 'a000000000000000000000000000002', 'quantjamie', 'Running my momentum scanner this morning, $NVDA keeps showing up at the top', null, '["NVDA"]', 0, '2024-02-05T09:32:11.000Z'),
('g0000000000000000000000000000003', 'a000000000000000000000000000003', 'sofiainvests', 'Just loaded up on $AAPL before earnings, feeling good about this one', null, '["AAPL"]', 0, '2024-02-07T10:05:44.000Z'),
('g0000000000000000000000000000004', 'a000000000000000000000000000001', 'traderpro', '$MSFT hitting new ATH, been holding since 280 and not selling', null, '["MSFT"]', 0, '2024-02-12T14:22:08.000Z'),
('g0000000000000000000000000000005', 'a000000000000000000000000000005', 'priyafinance', 'Anyone else watching the 10Y yield? Could affect tech names today', null, null, 0, '2024-02-14T08:45:33.000Z'),
('g0000000000000000000000000000006', 'a000000000000000000000000000004', 'marcusj_trades', '$AMD earnings beat expectations, afterhours looking nice', null, '["AMD"]', 0, '2024-02-20T16:35:19.000Z'),
('g0000000000000000000000000000007', 'a000000000000000000000000000002', 'quantjamie', 'My algo flagged $SMCI as overbought, be careful up here', null, '["SMCI"]', 0, '2024-02-22T11:18:55.000Z'),
('g0000000000000000000000000000008', 'a000000000000000000000000000001', 'traderpro', '$NVDA breaking out again, this stock is unstoppable', null, '["NVDA"]', 0, '2024-03-04T09:50:12.000Z'),
('g0000000000000000000000000000009', 'a00000000000000000000000000000b', 'aishap', 'Rotated my portfolio into $SPY and $QQQ, going safe for now', null, '["SPY","QQQ"]', 0, '2024-03-08T13:22:41.000Z'),
('g000000000000000000000000000000a', 'a000000000000000000000000000006', 'tylerb', 'Market feels toppy, adding some $GLD as a hedge', null, '["GLD"]', 0, '2024-03-11T10:08:37.000Z'),
('g000000000000000000000000000000b', 'a000000000000000000000000000003', 'sofiainvests', '$META earnings were insane, glad I held through the dip', null, '["META"]', 0, '2024-03-15T17:44:29.000Z'),
('g000000000000000000000000000000c', 'a000000000000000000000000000002', 'quantjamie', 'Backtested a mean reversion strategy on $AAPL, 68% win rate over 5 years', null, '["AAPL"]', 0, '2024-03-18T08:30:05.000Z'),
('g000000000000000000000000000000d', 'a000000000000000000000000000001', 'traderpro', 'Taking profits on $AMD, been a great run from 120 to 180', null, '["AMD"]', 0, '2024-03-22T15:12:48.000Z'),
('g000000000000000000000000000000e', 'a000000000000000000000000000007', 'meilin_stocks', 'Watching $BABA closely, China stimulus could be a catalyst', null, '["BABA"]', 0, '2024-03-25T09:55:33.000Z'),
('g000000000000000000000000000000f', 'a000000000000000000000000000004', 'marcusj_trades', '$TSLA on a tear, wish I bought more at 170', null, '["TSLA"]', 0, '2024-03-28T12:40:17.000Z'),
('g0000000000000000000000000000010', 'a000000000000000000000000000001', 'traderpro', 'CPI numbers coming in hot, buckle up folks', null, null, 0, '2024-04-02T08:28:44.000Z'),
('g0000000000000000000000000000011', 'a000000000000000000000000000005', 'priyafinance', '$GOOGL looking undervalued compared to the rest of mag 7', null, '["GOOGL"]', 0, '2024-04-05T11:15:22.000Z'),
('g0000000000000000000000000000012', 'a000000000000000000000000000002', 'quantjamie', 'Volatility crush after FOMC, my options plays are printing', null, null, 0, '2024-04-10T14:50:38.000Z'),
('g0000000000000000000000000000013', 'a000000000000000000000000000009', 'emmaw', 'New to the chat! Been trading for 2 years mostly $SPY options', null, '["SPY"]', 0, '2024-04-12T09:05:11.000Z'),
('g0000000000000000000000000000014', 'a000000000000000000000000000003', 'sofiainvests', 'Welcome emmaw! Great community here. I mostly swing trade tech', null, null, 0, '2024-04-12T09:18:55.000Z'),
('g0000000000000000000000000000015', 'a000000000000000000000000000001', 'traderpro', '$NVDA $AMD $AVGO — semis are the trade of the decade', null, '["NVDA","AMD","AVGO"]', 0, '2024-04-18T10:33:27.000Z'),
('g0000000000000000000000000000016', 'a00000000000000000000000000000c', 'ryankim', 'Anyone playing $COIN with the halving coming up?', null, '["COIN"]', 0, '2024-04-22T13:42:09.000Z'),
('g0000000000000000000000000000017', 'a000000000000000000000000000002', 'quantjamie', 'My $BTC model says 80K by end of Q2, let''s see', null, '["BTC"]', 0, '2024-04-25T08:20:44.000Z'),
('g0000000000000000000000000000018', 'a000000000000000000000000000004', 'marcusj_trades', 'Earnings season is wild, $NFLX beat and gapped up 10%', null, '["NFLX"]', 0, '2024-04-30T16:55:31.000Z'),
('g0000000000000000000000000000019', 'a000000000000000000000000000001', 'traderpro', 'Sold my $TSLA calls at open for 300% gain, best trade this month', null, '["TSLA"]', 0, '2024-05-06T09:48:22.000Z'),
('g000000000000000000000000000001a', 'a000000000000000000000000000011', 'chloed', 'What does everyone think about $PLTR at these levels?', null, '["PLTR"]', 0, '2024-05-10T11:30:15.000Z'),
('g000000000000000000000000000001b', 'a000000000000000000000000000003', 'sofiainvests', '$PLTR is solid long term but I''d wait for a pullback to 20', null, '["PLTR"]', 0, '2024-05-10T11:45:08.000Z'),
('g000000000000000000000000000001c', 'a000000000000000000000000000005', 'priyafinance', 'My $ETH position is finally in profit after months of waiting', null, '["ETH"]', 0, '2024-05-15T14:12:33.000Z'),
('g000000000000000000000000000001d', 'a000000000000000000000000000002', 'quantjamie', 'Correlation between $SPY and $TLT broke down again, interesting regime change', null, '["SPY","TLT"]', 0, '2024-05-20T10:05:47.000Z'),
('g000000000000000000000000000001e', 'a000000000000000000000000000001', 'traderpro', 'Summer trading is slow but I''m accumulating $AMZN on every dip', null, '["AMZN"]', 0, '2024-05-28T09:22:18.000Z'),
('g000000000000000000000000000001f', 'a000000000000000000000000000016', 'masonc', 'Just started following the chat, love the analysis here', null, null, 0, '2024-06-03T08:55:42.000Z'),
('g0000000000000000000000000000020', 'a000000000000000000000000000004', 'marcusj_trades', '$CRM reported strong guidance, enterprise software is back', null, '["CRM"]', 0, '2024-06-07T16:30:19.000Z'),
('g0000000000000000000000000000021', 'a000000000000000000000000000001', 'traderpro', 'Fed holding rates steady, $QQQ rally incoming', null, '["QQQ"]', 0, '2024-06-12T14:05:55.000Z'),
('g0000000000000000000000000000022', 'a000000000000000000000000000007', 'meilin_stocks', '$TSM is the real AI play, they make all the chips', null, '["TSM"]', 0, '2024-06-18T11:22:09.000Z'),
('g0000000000000000000000000000023', 'a000000000000000000000000000002', 'quantjamie', 'Running sector rotation analysis — energy looking oversold relative to tech', null, null, 0, '2024-06-22T09:40:33.000Z'),
('g0000000000000000000000000000024', 'a000000000000000000000000000003', 'sofiainvests', 'Added $COST to my long-term holds, recession-proof business', null, '["COST"]', 0, '2024-06-28T10:15:27.000Z'),
('g0000000000000000000000000000025', 'a000000000000000000000000000001', 'traderpro', 'Happy July 4th everyone! Markets closed but planning my $NVDA entry for Monday', null, '["NVDA"]', 0, '2024-07-04T12:00:05.000Z'),
('g0000000000000000000000000000026', 'a000000000000000000000000000005', 'priyafinance', 'Small caps finally waking up, $IWM breaking out of the range', null, '["IWM"]', 0, '2024-07-09T09:33:48.000Z'),
('g0000000000000000000000000000027', 'a000000000000000000000000000019', 'miat', 'Has anyone looked at $SHOP? Canadian tech seems underappreciated', null, '["SHOP"]', 0, '2024-07-15T13:18:22.000Z'),
('g0000000000000000000000000000028', 'a000000000000000000000000000002', 'quantjamie', 'Sharpe ratio on my portfolio hit 2.1 this quarter, best performance yet', null, null, 0, '2024-07-19T15:42:11.000Z'),
('g0000000000000000000000000000029', 'a000000000000000000000000000004', 'marcusj_trades', 'Rotation out of mega caps into mid caps happening right now', null, null, 0, '2024-07-24T10:28:55.000Z'),
('g000000000000000000000000000002a', 'a000000000000000000000000000001', 'traderpro', '$AAPL $MSFT $GOOGL all reporting this week, huge week ahead', null, '["AAPL","MSFT","GOOGL"]', 0, '2024-07-29T08:15:33.000Z'),
('g000000000000000000000000000002b', 'a000000000000000000000000000003', 'sofiainvests', '$AAPL crushed it! Services revenue is the real story', null, '["AAPL"]', 0, '2024-08-01T17:05:42.000Z'),
('g000000000000000000000000000002c', 'a00000000000000000000000000001e', 'danielk', 'The yen carry trade unwind is scary, keep some cash on the side', null, null, 0, '2024-08-05T09:10:28.000Z'),
('g000000000000000000000000000002d', 'a000000000000000000000000000002', 'quantjamie', 'VIX spiked to 38, haven''t seen that since 2020. Buying $UVXY puts', null, '["UVXY"]', 0, '2024-08-05T10:22:17.000Z'),
('g000000000000000000000000000002e', 'a000000000000000000000000000001', 'traderpro', 'Bought the dip on $NVDA at 95, this is a gift from the market gods', null, '["NVDA"]', 0, '2024-08-06T09:35:44.000Z'),
('g000000000000000000000000000002f', 'a000000000000000000000000000009', 'emmaw', 'That selloff was brutal but I held my positions, diamond hands', null, null, 0, '2024-08-07T11:50:33.000Z'),
('g0000000000000000000000000000030', 'a000000000000000000000000000006', 'tylerb', 'Picked up $INTC at 20, deep value or value trap? Time will tell', null, '["INTC"]', 0, '2024-08-12T14:15:09.000Z'),
('g0000000000000000000000000000031', 'a000000000000000000000000000005', 'priyafinance', '$GOLD breaking above 2500 for the first time ever, incredible', null, '["GOLD"]', 0, '2024-08-16T09:28:55.000Z'),
('g0000000000000000000000000000032', 'a000000000000000000000000000004', 'marcusj_trades', 'Jackson Hole speech could move markets big time tomorrow', null, null, 0, '2024-08-22T16:40:22.000Z'),
('g0000000000000000000000000000033', 'a000000000000000000000000000001', 'traderpro', 'Rate cuts confirmed for September, risk on baby! $QQQ $SPY', null, '["QQQ","SPY"]', 0, '2024-08-23T10:02:18.000Z'),
('g0000000000000000000000000000034', 'a000000000000000000000000000002', 'quantjamie', 'Updated my model for rate cuts, $XLF and $KRE should benefit most', null, '["XLF","KRE"]', 0, '2024-09-02T08:45:33.000Z'),
('g0000000000000000000000000000035', 'a000000000000000000000000000003', 'sofiainvests', 'September is historically the worst month, staying cautious', null, null, 0, '2024-09-05T11:20:47.000Z'),
('g0000000000000000000000000000036', 'a00000000000000000000000000000b', 'aishap', '$ARM is my sleeper pick for AI, everyone focuses on $NVDA but ARM designs are everywhere', null, '["ARM","NVDA"]', 0, '2024-09-10T13:55:11.000Z'),
('g0000000000000000000000000000037', 'a000000000000000000000000000001', 'traderpro', 'this message was posted by mistake ignore', null, null, 1, '2024-09-12T09:15:00.000Z'),
('g0000000000000000000000000000038', 'a000000000000000000000000000019', 'miat', 'Anyone else bullish on $UBER? Profitability story is real now', null, '["UBER"]', 0, '2024-09-15T10:30:28.000Z'),
('g0000000000000000000000000000039', 'a000000000000000000000000000002', 'quantjamie', 'Fed cut 50bps! Bigger than expected. $TLT ripping', null, '["TLT"]', 0, '2024-09-18T14:08:55.000Z'),
('g000000000000000000000000000003a', 'a000000000000000000000000000004', 'marcusj_trades', 'Bought $SQ on the dip, fintech is coming back with rate cuts', null, '["SQ"]', 0, '2024-09-22T09:42:17.000Z'),
('g000000000000000000000000000003b', 'a000000000000000000000000000001', 'traderpro', 'Q4 is historically the best quarter, loading up on calls', null, null, 0, '2024-10-01T08:30:22.000Z'),
('g000000000000000000000000000003c', 'a000000000000000000000000000011', 'chloed', '$DIS finally moving, theme parks and streaming both improving', null, '["DIS"]', 0, '2024-10-05T12:15:44.000Z'),
('g000000000000000000000000000003d', 'a000000000000000000000000000005', 'priyafinance', 'China stimulus is massive, $FXI and $KWEB exploding higher', null, '["FXI","KWEB"]', 0, '2024-10-08T09:55:33.000Z'),
('g000000000000000000000000000003e', 'a000000000000000000000000000002', 'quantjamie', 'My gamma exposure model shows dealers are very short, expect a squeeze', null, null, 0, '2024-10-12T10:40:18.000Z'),
('g000000000000000000000000000003f', 'a000000000000000000000000000003', 'sofiainvests', 'Earnings season starting again, I''m most excited about $AMZN', null, '["AMZN"]', 0, '2024-10-15T08:22:55.000Z'),
('g0000000000000000000000000000040', 'a000000000000000000000000000007', 'meilin_stocks', '$ASML dropped hard on weak guidance, but long term this is a buy', null, '["ASML"]', 0, '2024-10-18T15:30:09.000Z'),
('g0000000000000000000000000000041', 'a000000000000000000000000000001', 'traderpro', 'Election volatility is here, $VIX at 22. I''m selling premium', null, '["VIX"]', 0, '2024-10-25T09:18:42.000Z'),
('g0000000000000000000000000000042', 'a00000000000000000000000000000c', 'ryankim', '$MSTR is basically leveraged $BTC at this point, wild ride', null, '["MSTR","BTC"]', 0, '2024-10-30T13:25:17.000Z'),
('g0000000000000000000000000000043', 'a000000000000000000000000000004', 'marcusj_trades', 'Post-election rally is real, $SPY 600 by year end?', null, '["SPY"]', 0, '2024-11-06T10:05:33.000Z'),
('g0000000000000000000000000000044', 'a000000000000000000000000000002', 'quantjamie', 'accidental post, disregard', null, null, 1, '2024-11-08T08:12:00.000Z'),
('g0000000000000000000000000000045', 'a000000000000000000000000000001', 'traderpro', '$BTC just hit 80K! Anyone else watching $COIN and $MARA?', null, '["BTC","COIN","MARA"]', 0, '2024-11-11T09:42:28.000Z'),
('g0000000000000000000000000000046', 'a000000000000000000000000000006', 'tylerb', 'Thanksgiving rally started early this year, fully invested', null, null, 0, '2024-11-18T11:30:55.000Z'),
('g0000000000000000000000000000047', 'a000000000000000000000000000003', 'sofiainvests', '$NVDA earnings tomorrow, my biggest position. Nervous but confident', null, '["NVDA"]', 0, '2024-11-20T16:45:12.000Z'),
('g0000000000000000000000000000048', 'a000000000000000000000000000005', 'priyafinance', '$NVDA beat again but stock sold off, buy the dip opportunity?', null, '["NVDA"]', 0, '2024-11-21T10:15:38.000Z'),
('g0000000000000000000000000000049', 'a000000000000000000000000000001', 'traderpro', 'Year end tax loss harvesting time, selling my losers and buying back in Jan', null, null, 0, '2024-12-02T09:08:22.000Z'),
('g000000000000000000000000000004a', 'a00000000000000000000000000001e', 'danielk', '$SNOW upgraded by multiple analysts, cloud spending is accelerating', null, '["SNOW"]', 0, '2024-12-06T14:20:45.000Z'),
('g000000000000000000000000000004b', 'a000000000000000000000000000002', 'quantjamie', 'Year in review: my quant portfolio returned 34%, mostly driven by $NVDA and $META', null, '["NVDA","META"]', 0, '2024-12-15T10:30:11.000Z'),
('g000000000000000000000000000004c', 'a000000000000000000000000000016', 'masonc', '$RDDT has been a beast since IPO, social media play of the year', null, '["RDDT"]', 0, '2024-12-18T12:45:33.000Z'),
('g000000000000000000000000000004d', 'a000000000000000000000000000003', 'sofiainvests', 'Santa rally is real! Portfolio up 3% this week alone', null, null, 0, '2024-12-23T09:55:18.000Z'),
('g000000000000000000000000000004e', 'a000000000000000000000000000001', 'traderpro', 'Happy New Year traders! 2025 is going to be huge, I can feel it', null, null, 0, '2025-01-02T09:00:15.000Z'),
('g000000000000000000000000000004f', 'a000000000000000000000000000004', 'marcusj_trades', '$SOFI is my top fintech pick for 2025, student loan tailwinds', null, '["SOFI"]', 0, '2025-01-06T11:22:38.000Z'),
('g0000000000000000000000000000050', 'a000000000000000000000000000002', 'quantjamie', 'New year new strategy — adding a volatility harvesting component to my algo', null, null, 0, '2025-01-10T08:40:55.000Z'),
('g0000000000000000000000000000051', 'a000000000000000000000000000009', 'emmaw', '$AAPL car project cancelled, all focus on AI now. Bullish or bearish?', null, '["AAPL"]', 0, '2025-01-15T13:18:27.000Z'),
('g0000000000000000000000000000052', 'a000000000000000000000000000001', 'traderpro', 'DeepSeek shaking up the AI trade, $NVDA down 15% in a day. I''m buying', null, '["NVDA"]', 0, '2025-01-27T10:05:44.000Z'),
('g0000000000000000000000000000053', 'a000000000000000000000000000005', 'priyafinance', 'This DeepSeek panic is overdone, $MSFT and $GOOGL AI spending isn''t slowing', null, '["MSFT","GOOGL"]', 0, '2025-01-28T09:30:12.000Z'),
('g0000000000000000000000000000054', 'a000000000000000000000000000003', 'sofiainvests', 'Bought the $NVDA dip at 115, these panic selloffs always recover', null, '["NVDA"]', 0, '2025-01-29T11:42:33.000Z'),
('g0000000000000000000000000000055', 'a000000000000000000000000000002', 'quantjamie', 'My models show the AI trade is broadening, $DELL $HPE $SMCI all benefiting', null, '["DELL","HPE","SMCI"]', 0, '2025-02-03T08:55:19.000Z'),
('g0000000000000000000000000000056', 'a00000000000000000000000000000b', 'aishap', 'Super Bowl coming up, historically bullish for $SPY in February', null, '["SPY"]', 0, '2025-02-07T10:12:44.000Z'),
('g0000000000000000000000000000057', 'a000000000000000000000000000004', 'marcusj_trades', '$LLY pulled back hard, obesity drug thesis is intact though', null, '["LLY"]', 0, '2025-02-12T14:35:28.000Z'),
('g0000000000000000000000000000058', 'a000000000000000000000000000001', 'traderpro', 'Anyone else watching $BTC? 100K is happening, just a matter of when', null, '["BTC"]', 0, '2025-02-18T09:20:55.000Z'),
('g0000000000000000000000000000059', 'a000000000000000000000000000019', 'miat', '$TSM earnings were monster, AI chip demand is insatiable', null, '["TSM"]', 0, '2025-02-25T11:08:33.000Z'),
('g000000000000000000000000000005a', 'a000000000000000000000000000007', 'meilin_stocks', 'Tariff fears hitting $BABA again, but I think the worst is priced in', null, '["BABA"]', 0, '2025-03-04T13:45:17.000Z'),
('g000000000000000000000000000005b', 'a000000000000000000000000000002', 'quantjamie', 'March is historically choppy, reducing position sizes by 20%', null, null, 0, '2025-03-10T08:30:42.000Z'),
('g000000000000000000000000000005c', 'a000000000000000000000000000001', 'traderpro', '$TSLA robotaxi event was disappointing, sold my position at 175', null, '["TSLA"]', 0, '2025-03-15T10:55:18.000Z'),
('g000000000000000000000000000005d', 'a000000000000000000000000000011', 'chloed', 'Just opened a position in $V, payments is a boring but great business', null, '["V"]', 0, '2025-03-22T12:30:44.000Z'),
('g000000000000000000000000000005e', 'a000000000000000000000000000005', 'priyafinance', 'Yield curve un-inverting, historically that''s when recessions actually start', null, null, 0, '2025-04-01T09:15:33.000Z'),
('g000000000000000000000000000005f', 'a000000000000000000000000000003', 'sofiainvests', 'Good morning everyone! Markets looking green today after the pullback', null, null, 0, '2025-04-08T09:05:22.000Z'),
('g0000000000000000000000000000060', 'a00000000000000000000000000000c', 'ryankim', '$BTC finally broke 100K! What a time to be alive', null, '["BTC"]', 0, '2025-04-15T08:42:11.000Z'),
('g0000000000000000000000000000061', 'a000000000000000000000000000002', 'quantjamie', 'Rebalanced into $SCHD for the dividend yield, 3.5% is attractive here', null, '["SCHD"]', 0, '2025-05-02T10:20:38.000Z'),
('g0000000000000000000000000000062', 'a000000000000000000000000000006', 'tylerb', 'Summer doldrums hitting early, volume is way down', null, null, 0, '2025-05-18T11:35:55.000Z'),
('g0000000000000000000000000000063', 'a000000000000000000000000000016', 'masonc', 'wrong chat lol', null, null, 1, '2025-05-22T14:10:00.000Z'),
('g0000000000000000000000000000064', 'a000000000000000000000000000001', 'traderpro', '$AAPL WWDC blew my mind, AI integration across all devices. All in.', null, '["AAPL"]', 0, '2025-06-10T10:45:33.000Z');
```

## Summary

- **Total messages**: 100
- **Date range**: Feb 2024 - Jun 2025 (with room for future additions through Feb 2026)
- **Deleted messages**: 3 (IDs: 037, 044, 063)
- **Messages with tickers**: ~60%
- **Distribution**:
  - traderpro: 15 messages
  - quantjamie: 12 messages
  - sofiainvests: 10 messages
  - marcusj_trades: 8 messages
  - priyafinance: 8 messages
  - tylerb: 4 messages
  - meilin_stocks: 4 messages
  - emmaw: 3 messages
  - aishap: 3 messages
  - ryankim: 3 messages
  - chloed: 3 messages
  - masonc: 3 messages
  - miat: 3 messages
  - danielk: 2 messages
