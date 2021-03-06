% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wkb.R
\name{st_as_binary}
\alias{st_as_binary}
\alias{st_as_binary.sfc}
\alias{st_as_binary.sfg}
\title{Convert sfc object to an WKB object}
\usage{
st_as_binary(x, ...)

\method{st_as_binary}{sfc}(
  x,
  ...,
  EWKB = FALSE,
  endian = .Platform$endian,
  pureR = FALSE,
  precision = attr(x, "precision"),
  hex = FALSE
)

\method{st_as_binary}{sfg}(
  x,
  ...,
  endian = .Platform$endian,
  EWKB = FALSE,
  pureR = FALSE,
  hex = FALSE
)
}
\arguments{
\item{x}{object to convert}

\item{...}{ignored}

\item{EWKB}{logical; use EWKB (PostGIS), or (default) ISO-WKB?}

\item{endian}{character; either "big" or "little"; default: use that of platform}

\item{pureR}{logical; use pure R solution, or C++?}

\item{precision}{numeric; if zero, do not modify; to reduce precision: negative values convert to float (4-byte real); positive values convert to round(x*precision)/precision. See details.}

\item{hex}{logical; return as (unclassed) hexadecimal encoded character vector?}
}
\description{
Convert sfc object to an WKB object
}
\details{
\code{st_as_binary} is called on sfc objects on their way to the GDAL or GEOS libraries, and hence does rounding (if requested) on the fly before e.g. computing spatial predicates like \link{st_intersects}. The examples show a round-trip of an \code{sfc} to and from binary.

For the precision model used, see also \url{https://locationtech.github.io/jts/javadoc/org/locationtech/jts/geom/PrecisionModel.html}. There, it is written that: ``... to specify 3 decimal places of precision, use a scale factor of 1000. To specify -3 decimal places of precision (i.e. rounding to the nearest 1000), use a scale factor of 0.001.''. Note that ALL coordinates, so also Z or M values (if present) are affected.
}
\examples{
# examples of setting precision:
st_point(c(1/3, 1/6)) \%>\% st_sfc(precision = 1000) \%>\% st_as_binary \%>\% st_as_sfc
st_point(c(1/3, 1/6)) \%>\% st_sfc(precision =  100) \%>\% st_as_binary \%>\% st_as_sfc
st_point(1e6 * c(1/3, 1/6)) \%>\% st_sfc(precision = 0.01) \%>\% st_as_binary \%>\% st_as_sfc
st_point(1e6 * c(1/3, 1/6)) \%>\% st_sfc(precision = 0.001) \%>\% st_as_binary \%>\% st_as_sfc
}
