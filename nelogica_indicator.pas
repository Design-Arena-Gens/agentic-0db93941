// Indicador personalizado para ProfitChart Pro
// Calcula duas médias exponenciais suavizadas e um histograma de impulso

inputs:
    FastLength(9),
    SlowLength(21),
    SignalLength(5);

vars:
    FastEMA(0),
    SlowEMA(0),
    SignalLine(0),
    Histogram(0),
    FastAlpha(0),
    SlowAlpha(0),
    SignalAlpha(0);

FastAlpha = 2.0 / (FastLength + 1);
SlowAlpha = 2.0 / (SlowLength + 1);
SignalAlpha = 2.0 / (SignalLength + 1);

if CurrentBar = 1 then
begin
    FastEMA = Close;
    SlowEMA = Close;
    Histogram = 0;
    SignalLine = 0;
end
else
begin
    FastEMA = FastEMA[1] + FastAlpha * (Close - FastEMA[1]);
    SlowEMA = SlowEMA[1] + SlowAlpha * (Close - SlowEMA[1]);
    Histogram = FastEMA - SlowEMA;
    SignalLine = SignalLine[1] + SignalAlpha * (Histogram - SignalLine[1]);
end;

Histogram = FastEMA - SlowEMA;

if CurrentBar = 1 then
    SignalLine = Histogram;

Plot(1, FastEMA, 'EMA_Rapida');
Plot(2, SlowEMA, 'EMA_Lenta');
Plot(3, Histogram, 'Impulso');
Plot(4, SignalLine, 'Linha_Sinal');

if Histogram > SignalLine then
begin
    SetPlotColor(3, RGB(0, 170, 0));
    SetPlotColor(4, RGB(0, 120, 255));
end
else
begin
    SetPlotColor(3, RGB(220, 0, 0));
    SetPlotColor(4, RGB(255, 130, 0));
end;

if CrossOver(Histogram, SignalLine) then
    PlotShape(true, shapeTriangleUp, 0, Histogram, RGB(0, 200, 0));

if CrossUnder(Histogram, SignalLine) then
    PlotShape(true, shapeTriangleDown, 0, Histogram, RGB(220, 0, 0));
