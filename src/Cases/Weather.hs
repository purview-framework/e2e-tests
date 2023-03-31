{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GHC2021 #-}
module Cases.Weather where

import Prelude hiding (div)

import Network.HTTP.Req
import Data.Aeson
import Purview

-----------
-- Model --
-----------

data Day = Day
  { name :: String
  , temperature :: Int
  } deriving (Show, Eq)

newtype Forecast = Forecast [Day]
  deriving (Show, Eq)

instance FromJSON Day where
  parseJSON (Object obj) = Day <$> obj .: "name" <*> obj .: "temperature"
  parseJSON _ = undefined

instance FromJSON Forecast where
  parseJSON (Object obj) = Forecast <$> (obj .: "properties" >>= (.: "periods"))
  parseJSON _ = undefined

----------
-- View --
----------

dayView :: Day -> Purview event m
dayView Day { name, temperature } = div
  [ text $ "the temperature for " <> name <> " is " <> show temperature ]

forecastView :: State -> Purview event m
forecastView state = case state of
  Init                   -> div []
  Loading                -> div [ text "loading" ]
  Loaded (Forecast days) -> div (fmap dayView days)

view :: State -> Purview event m
view state = div
  [ text "Blank"
  , forecastView state
  ]

-------------
-- Reducer --
-------------

data Actions
  = StartWeatherRequest String String
  | WeatherRequest String String
  deriving (Show, Eq)

data State
  = Init
  | Loading
  | Loaded Forecast
  deriving (Show, Eq)

weatherReducer :: Actions -> State -> IO (State -> State, [DirectedEvent parentAction Actions])
weatherReducer (StartWeatherRequest lat lon) state =
  pure (const $ Loading, [Self $ WeatherRequest lat lon])
weatherReducer (WeatherRequest lat lon) state = do
  weather <- fetchWeather
  pure (const $ Loaded weather, [])

weatherHandler :: (State -> Purview Actions IO) -> Purview parentEvent IO
weatherHandler = effectHandler
  [Self $ StartWeatherRequest "" ""] -- initial events
  Init                               -- initial state
  weatherReducer                     -- event reducer

---------
-- API --
---------

fetchWeather :: IO Forecast
fetchWeather = runReq defaultHttpConfig $ do
  let userAgent = header "User-Agent" "(purview.org, bontaq@gmail.com)"

  res <- req GET
    (https "api.weather.gov" /: "gridpoints" /: "TOP" /: "31,80" /: "forecast")
    NoReqBody
    jsonResponse
    userAgent

  pure (responseBody res :: Forecast)

------------------
-- All Together --
------------------

render :: Purview parentEvent IO
render = weatherHandler view
