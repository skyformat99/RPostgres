#' @include driver.R
#' @export
setClass("PqConnection",
  contains = "DBIConnection",
  slots = list(ptr = "externalptr")
)

#' Connect to a PostgreSQL database.
#'
#' @param drv \code{rpg::pq()}
#' @param dbname Database name. If \code{NULL}, defaults to the user name.
#' @param user,password User name and password. If \code{NULLL}, will be
#'   retrieved from \code{PGUSER} and \code{PGPASSWORD} envvars, or from the
#'   appropriate line in \code{~/.pgpass}. See below for details.
#' @param host,port Host and port. If \code{NULL}, will be retrieved from
#'   \code{PGHOST} and \code{PGPORT} env vars.
#' @param ... Other name-value pairs that describe additional connection
#'   options as described at
#'   \url{http://www.postgresql.org/docs/9.4/static/libpq-connect.html#LIBPQ-PARAMKEYWORDS}
#' @aliases PqConnection-class
#' @export
#' @examples
#' \donttest{
#' dbConnect(pq())
#' }
setMethod("dbConnect", "PqDriver", function(drv, dbname = NULL,
  host = NULL, port = NULL, password = NULL, user = NULL, ...) {

  opts <- unlist(list(dbname = dbname, user = user, password = password,
    host = host, port = as.character(port)))
  if (!is.character(opts)) {
    stop("All options should be strings", call. = FALSE)
  }

  if (length(opts) == 0) {
    ptr <- connect(character(), character())
  } else {
    ptr <- connect(names(opts), as.vector(opts))
  }

  new("PqConnection", ptr = ptr)
})
