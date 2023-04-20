{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GHC2021 #-}
module Cases.Weather where

import Prelude hiding (div)

import Network.HTTP.Req
import Data.Aeson
import Data.Aeson.Types
import Data.Text
import Purview
import Cases.BasicsAndAttributes (nameAttr)


typeAttr = Attribute . Generic "type"

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

latLonForm :: Purview (Maybe String) m
latLonForm = onSubmit id $ form
  [ nameAttr "latitude" $ input []
  , nameAttr "longitude" $ input []
  , typeAttr "submit" $ button [ text "Get Weather" ]
  ]

-------------
-- Reducer --
-------------

data Actions
  = LoadWeather String String
  | RequestWeather (Maybe String)
  deriving (Show, Eq)

data State
  = Init
  | Loading
  | Loaded Forecast
  deriving (Show, Eq)

weatherReducer :: Actions -> State -> IO (State -> State, [DirectedEvent parentAction Actions])
weatherReducer (RequestWeather raw) state =
  let
    lat = ""
    lon = ""
  in
    pure (const $ Loading, [Self $ LoadWeather lat lon])
weatherReducer (LoadWeather lat lon) state = do
  forecastLocation <- fetchForecast (lat, lon)

  case forecastLocation of
    Just forecastLocation' -> do
      weather <- fetchWeather forecastLocation'
      pure (const $ Loaded weather, [])
    Nothing ->
      pure (id, [])

weatherHandler :: (State -> Purview Actions IO) -> Purview parentEvent IO
weatherHandler = effectHandler
  []              -- initial events
  Init            -- initial state
  weatherReducer  -- event reducer

---------
-- API --
---------

userAgent :: Option scheme
userAgent = header "User-Agent" "(purview.org, bontaq@gmail.com)"

fetchWeather :: String -> IO Forecast
fetchWeather forecastLocation = runReq defaultHttpConfig $ do
  res <- req GET
    (https "api.weather.gov" /: "gridpoints" /: "TOP" /: "31,80" /: "forecast")
    NoReqBody
    jsonResponse
    userAgent

  pure (responseBody res :: Forecast)

fetchForecast :: (String, String) -> IO (Maybe String)
fetchForecast (lat, lon) = runReq defaultHttpConfig $ do
  res <- req GET
    (https "api.weather.gov" /: "points" /: (pack lat <> "," <> pack lon))
    NoReqBody
    jsonResponse
    userAgent

  let
    response = responseBody res :: Object
    forecast = parseMaybe
      (\item -> item .: "properties" >>= (.: "forecast")) response :: Maybe String

  pure forecast


------------------
-- All Together --
------------------

render :: Purview parentEvent IO
render = weatherHandler view
