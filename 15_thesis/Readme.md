# Intro to Volatility GARCH Modeling
## Volatility spillover study of US-Mainland China real estate
September 1, 2012

### Overview

**Please find the thesis work [here](https://github.com/garthmortensen/finance/blob/master/Volatility_Spillover.pdf)**.

This was thesis work for an MSc in Finance. It studies two time-series of stock market indices, using an abnormal approach.

Market returns are not independent and identically distributed. Meanwhile, you can think of price movement as a simple white noise process. [Random Walk Down Wall Street](https://www.amazon.com/Random-Walk-Down-Wall-Street/dp/0393330338) and other classics repeatedly tell a fundamental law of the markets – you can’t predict prices. In physics, the most widely tested and asserted hypothesis is E = MC<sup>2</sup>. In finance, it is that prices are independent and identically distributed processes.

But that’s not the end of rational market investment. Just as you can take the derivative of speed to obtain acceleration, you can take the derivative of price to obtain returns. Returns really are, in fact, not white noise processes ([Alexandre](https://www.amazon.com/Market-Risk-Analysis-Practical-Econometrics/dp/B00HMUJC5A) pg 131). This idea is what validates a detailed study of the returns process and volatility.

### Model
Mastering the multivariate GARCH spillover methodology is in itself challenging, and made more so by the absence of relevant online content. I've posted my work here to fill that void and help future researchers. I've tried to illustrate everything as clearly as possible, but please recommend improvements.

Over the past decades GARCH models have quickly proliferated through finance, perhaps owing mostly to its wide applicability. Once researchers extended GARCH to the multivariate universe they found it could be used to illuminate how volatility (returns<sup>2</sup>) spills over from one time series to another. So for instance, you can use this technique to see how a jump in corn price volatility associates to one in ethanol, or vice versa.

Modeling techniques include:
1. Univariate and multivariate-generalized autoregressive conditional heteroskedasticity (MV-GARCH)
2. Constant conditional correlation (CCC)
3. Dynamic conditional correlation (DCC) using,
4. Exponentially weighted moving average (EWMA) covariance

### Dataset
My work applies MV-GARCH to the daily closing prices of real estate ETFs listed in the US and Mainland China markets. Results show how vulnerable US property is to a potential Chinese property bubble (a subject of ongoing debate). In addition to presenting the methodology I've also made the code freely available here. It's all properly formatted and explained within so you can quickly integrate it. If your interested in understanding how overall Chinese stock market volatility is affecting France, you simply import the [Shanghai Composite Index](http://finance.yahoo.com/q/hp?s=000001.SS+Historical+Prices) and [CAC40](http://finance.yahoo.com/q/hp?s=%5eFCHI+Historical+Prices) downloadable Yahoo! spreadsheet files. By using this study's plain vanilla approach, more attention can be given to estimating meaningful, interpretable parameters than solving the computational difficulties associated with more complex GARCH variations. Now let's discuss the procedure.

### GARCH Walkthrough
This GARCH study is two-step. First, ARMA equations are estimated to extract each market's conditional mean. Then, residuals are used to estimate GARCH equations for extracting the conditional variance.

However, before estimating the model, some filtration is needed. This is because the Chinese and US markets don't have synchronous trading hours or completely common holidays (**Figures 1 and 2**). Depending on your study, these may need to be corrected for.

![trading hours](https://raw.githubusercontent.com/garthmortensen/finance/master/images/time.png)

![trading days](https://raw.githubusercontent.com/garthmortensen/finance/master/images/tradingdays.png)

Once your data is prepped, you can begin by feeding the return series into an autoregressive moving average (ARMA) model. This renders a white-noise, zero-mean process. The error term from this can be interpreted as the unexpected return or market shock (**Figure 3**). Cool?

![GARCH eq](https://raw.githubusercontent.com/garthmortensen/finance/master/images/ARMA.png)

![market shock](https://raw.githubusercontent.com/garthmortensen/finance/master/images/market%20shock.png)

Error term in hand, you can continue to the next step: GARCH. Just as before, you estimate the parameters and pull out the residuals. This resultant series reveals conditional variance. Finally, apply the square root of time rule to obtain conditional volatility (**Figure 4**).

![lambda](https://raw.githubusercontent.com/garthmortensen/finance/master/images/GARCH.png)

![EWMA Covariance](https://raw.githubusercontent.com/garthmortensen/finance/master/images/GARCH%20uni.png)

Kevin Sheppard's [UCSD GARCH Toolbox](https://www.kevinsheppard.com/code/matlab/ucsd-garch/) and James P. LeSage's [Econometrics Toolbox](https://www.spatial-econometrics.com/) are used in the study.

As said, this model is relatively quite simple, making its omega (ω, w), alpha (α, a) and beta (β, b) parameters easier to interpret. Alpha measures how sensitive conditional volatility is to market shocks. The larger its value, the more sensitive conditional volatility is. Beta tells the persistence of conditional volatility when the market is devoid of shocks. The larger its value, the longer it takes for volatility to fade out. Don't forget to check your t-stats.

Finally, we have the multivariate part.

Because this study examines how one market's volatility impacts another, we still need to see how they interact. We're faced with several paths to take, each varying in their complexity. The easiest is to stitch together the two univariate volatility series together using a constant correlation coefficient (CCC). Its assumption that correlation remains constant goes against most real world observations. This may be a most-welcome simplification if you're juggling 15 indices, but a more sophisticated approach allows it to change with time. This can be done with the dynamic conditional correlation (DCC) method. To calculate this, one may follow a technique developed by RiskMetrics, where exponentially weighted moving averages are weighted by customized lambda parameters (**Figure 5**).

![lambda](https://raw.githubusercontent.com/garthmortensen/finance/master/images/lambda.png)

![EWMA covariance](https://raw.githubusercontent.com/garthmortensen/finance/master/images/EWMA%20copy.png)

In fact, there are many, many, alternative methods. The entire GARCH model universe consists of at least 300 variations. Some incorporate asymmetries, fat-tails, or bi-directional spillovers. But since the vast majority of these, especially multivariate estimation, aren't supported by software, your choices will be limited by your programming proficiency. Despite your methodology, in the end you're left with a view of how conditional volatility in one market impacts that in another. My specific case study and results are found here.

## Your Part
In the spirit open source, I leave you with the keys to the kingdom below. The work is easily adjustable so others can benefit. Everything was designed for this purpose. All you need to do is download two price series from either Yahoo! Finance or Datastream, rename the files, and then edit a few lines of code. 

*Happy GARCHing!*

中国的言语学生经济分析-如果你们有一个小问题请加我的联系!

## Additional Resources
The study employs the MV-GARCH methodology outlined by [Sergio Focardi et. al](https://www.amazon.com/Financial-Econometrics-Advanced-Modeling-Techniques/dp/0471784508/ref=pd_sim_b_65) and [Carol Alexander](https://www.amazon.com/Analysis-Practical-Financial-Econometrics-Finance/dp/0470998016/ref=sr_1_4?s=books&ie=UTF8&qid=1347558126&sr=1-4&keywords=carol+alexander), whose books provide the clearest direction on the multivariate subject. Alexander's [Market Risk Analysis Forum](http://www.carolalexander.org/) (now defunct?) also includes an entire section dedicated to GARCH. Further, Robert Engle, a co-developer of the model, has a few introductory videos on the univariate model [here](https://www.ft.com/topics/organisations/New_York_University_Stern_School_of_Business).

### Thinking outside the white/black box

Even if correct, your model may not hold water. Double check your underlying theories. When it comes to econometrics, don't forget what all the equilibrium models are based off of, which are ideas like everyone has access to equal information, all actors are rational, and some other clearly irrational assumptions.

For those interested in the economic mechanics of bubbles, please examine Hyman Minsky's [theories on debt](https://en.wikipedia.org/wiki/Hyman_Minsky#Financial_theory) and Steve Keene's (of [Debtwatch](http://www.debtdeflation.com/blogs/)) [commentaries](https://www.youtube.com/watch?v=SkesgECRXtM) on the 2008 financial crisis. Robert J. Schiller's book [Irrational Exuberance](https://www.amazon.com/Irrational-Exuberance-Robert-J-Shiller/dp/0767923634) also delved into it quite nicely. Check them out - they may change your perspective.

