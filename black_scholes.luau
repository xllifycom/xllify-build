-- Normal CDF approximation using Abramowitz and Stegun method
local function normCDF(x)
    if x < -7 then
        return 0
    elseif x > 7 then
        return 1
    end

    local sign = 1
    if x < 0 then
        sign = -1
        x = -x
    end

    local t = 1 / (1 + 0.2316419 * x)
    local y = t * (0.31938153 + t * (-0.356563782 + t * (1.781477937 + t * (-1.821255978 + t * 1.330274429))))
    local z = math.exp(-x * x / 2) / math.sqrt(2 * math.pi)

    if sign == 1 then
        return 1 - z * y
    else
        return z * y
    end
end

-- Black-Scholes formula for call and put options
local function blackScholes(S, K, T, r, sigma, optionType)    
    if T <= 0 then
        if optionType == "call" then
            return math.max(S - K, 0)
        else
            return math.max(K - S, 0)
        end
    end
    
    local d1 = (math.log(S / K) + (r + sigma * sigma / 2) * T) / (sigma * math.sqrt(T))
    local d2 = d1 - sigma * math.sqrt(T)
    
    if optionType == "call" then
        return S * normCDF(d1) - K * math.exp(-r * T) * normCDF(d2)
    else -- put
        return K * math.exp(-r * T) * normCDF(-d2) - S * normCDF(-d1)
    end
end

xllify.ExcelFunction({
    name = "bs.Call",
    description = "Black-Scholes call option price",
    parameters = {
        {name="S", description="Current stock price"},
        {name="K", description="Strike price"},
        {name="T", description="Time to expiration (years)"},
        {name="r", description="Risk-free interest rate"},
        {name="sigma", description="Volatility (annualized)"}
    }
 }, 
    function (S: number, K: number, T: number, r: number, sigma: number): number
        return blackScholes(S, K, T, r, sigma, "call")
    end
)

xllify.ExcelFunction({
    name = "bs.Put",
    description = "Black-Scholes put option price"
 }, 
    function (S: number, K: number, T: number, r: number, sigma: number): number
        return blackScholes(S, K, T, r, sigma, "put")
    end
)
