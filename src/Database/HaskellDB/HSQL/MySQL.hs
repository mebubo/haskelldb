-----------------------------------------------------------
-- |
-- Module      :  HaskellDB
-- Copyright   :  Daan Leijen (c) 1999, daan@cs.uu.nl
--                HWT Group (c) 2003, dp03-7@mdstud.chalmers.se
-- License     :  BSD-style
-- 
-- Maintainer  :  dp03-7@mdstud.chalmers.se
-- Stability   :  experimental
-- Portability :  non-portable
--
--
-- $Revision: 1.9 $
-----------------------------------------------------------
module Database.HaskellDB.HSQL.MySQL (
		   MySQLOptions(..),
		   mysqlConnect,
		   driver
		  ) where

import Database.HaskellDB.Database
import Database.HaskellDB.HSQL.Common
import Database.HaskellDB.DriverAPI
import qualified Database.HSQL.MySQL as MySQL (connect) 

data MySQLOptions = MySQLOptions { 
				  server :: String, -- ^ server name
				  db :: String,     -- ^ database name
				  uid :: String,    -- ^ user id
				  pwd :: String     -- ^ password
                  		 }

mysqlConnect :: MySQLOptions -> (Database -> IO a) -> IO a
mysqlConnect = 
    hsqlConnect (\opts -> MySQL.connect 
		            (server opts) (db opts) (uid opts) (pwd opts))

mysqlFlatConnect :: [String] -> (Database -> IO a) -> IO a
mysqlFlatConnect (a:b:c:d:[]) = mysqlConnect (MySQLOptions {
							    server = a,
							    db = b,
							    uid = c,
							    pwd = d})
mysqlFlatConnect _ = error "mysqlFlatConnect failed: Invalid number of arguments"

driver = defaultdriver {connect = mysqlFlatConnect}
