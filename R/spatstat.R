window_polygons_from_edges = function (w) {
  mw = as.matrix(w$ends)
  lst1 = lapply(seq_len(NROW(mw)), function(i) st_linestring(matrix(mw[i,], 2, byrow = TRUE)))
  p0 = st_polygonize(do.call(c, do.call(st_sfc, lst1)))
  if (length(p0) > 1) # multiple POLYGONs, returned as sfc_
  	do.call(c, st_collection_extract(p0, "POLYGON")) # MULTIPOLYGON
  else
  	st_cast(p0, "POLYGON")
}

#' @name st_as_sf
#' @export
#' @examples
#' if (require(spatstat)) {
#'   g = st_as_sf(gorillas)
#'   # select only the points:
#'   g[st_is(g, "POINT"),]
#' }
st_as_sf.ppp = function(x, ...) {
  if (!requireNamespace("spatstat", quietly = TRUE))
    stop("package spatstat required, please install it first") # nocov
  # window:
  pol = window_polygons_from_edges(spatstat::edges(x$window))
  label = c("window")
  winwork_sf = st_sf(label = label, geom = st_sfc(c(list(pol))))

  # points:
  m = as.matrix(data.frame(x$x, x$y))
  pointwork = st_sfc(lapply(seq_len(NROW(m)), function(i) st_point(m[i,])))
  points_sf = st_sf(label = rep("point", NROW(m)), geom = pointwork)

  # merge window and points:
  ret = rbind(winwork_sf, points_sf)
  if (spatstat::is.marked(x)) {
	# add marks:
    m = as.data.frame(spatstat::marks(x))
	cbind.sf(ret, m[c(NA, seq_len(nrow(m))),])
  } else
  	ret
}


#' @name st_as_sf
#' @export
st_as_sf.psp = function(x, ...) {
	if (!requireNamespace("spatstat", quietly = TRUE))
		stop("package spatstat required, please install it first")
	# line segments:
 	m = as.matrix(x$ends)
	lst1 = lapply(seq_len(NROW(m)), function(i) st_linestring(matrix(m[i,], 2, byrow = TRUE)))

	# window:
	pol = window_polygons_from_edges(spatstat::edges(x))

	label = c("window", rep("segment", NROW(m)))
	st_sf(label = label, geom = st_sfc(c(list(pol), lst1)))
}


#' @name st_as_sf
#' @export
#' @examples
#' if (require(spatstat)) {
#'  data(chicago)
#'  plot(st_as_sf(chicago)["label"])
#'  plot(st_as_sf(chicago)[-1,"label"])
#' }
st_as_sf.lpp = function(x, ...) {
	if (!requireNamespace("spatstat", quietly = TRUE))
		stop("package spatstat required, please install it first")
	# lines, polygon:
	linework_sf = st_as_sf(spatstat::as.psp(spatstat::domain(x)))
	# points:
	m = as.matrix(as.data.frame(x$data)[1:2])
	pointwork = st_sfc(lapply(seq_len(NROW(m)), function(i) st_point(m[i,])))
	sf = rbind(linework_sf, st_sf(label = rep("point", NROW(m)), geom = pointwork))
	# de-select point coordinates
	m = as.data.frame(x$data)[c(rep(NA,nrow(linework_sf)),seq_len(nrow(m))), -(1:2)]
	structure(cbind.sf(sf, m), row.names = seq_len(nrow(m)))
}
