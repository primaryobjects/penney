packages <- c('ggplot2', 'maps', 'ggmap')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

if (!require("ghit")) {
  install.packages("ghit")
  # on 64-bit Windows
  ghit::install_github(c("ropensci/tabulizerjars", "ropensci/tabulizer"), INSTALL_opts = "--no-multiarch")
  # elsewhere
  #ghit::install_github(c("ropensci/tabulizerjars", "ropensci/tabulizer"))
}

library(tabulizer)
library(ggplot2)
library(maps)
library(ggmap)

# Read PDF and extract data.
url <- 'http://www.jcpnewsroom.com/news-releases/2017/assets/0317_list_of_store_closures.pdf'
data <- extract_tables(url, guess = F, area = list(c(300, 0, 800, 800), c(0, 0, 800, 800), c(0, 0, 800, 800), c(0, 0, 800, 800)))

# Remove missing column and skip first row (table header).
data[[1]] <- data[[1]][-1, c(1,2,4)]

# Combine pages into a single set and cast to data.frame.
data <- as.data.frame(do.call(rbind, data[1:length(data)]))

# Set column names.
names(data) <- c('Mall', 'City', 'State')

states <- map_data('state')
counties <- map_data('county')

# Get lat/long coordinates for each location.
set <- paste(data$City, data$State, sep=' ')
data <- cbind(data, geocode(set))
data$group=0

# Get counts of closures per state (for coloring on map).
countPerState <- as.data.frame(table(data$State))
names(countPerState) <- c('abb', 'freq')

# Get state map.
US <- map_data("state")

# Get state abbreviations.
US$abb <- sapply(US$region, function(region) { 
  c(state.abb[region == tolower(state.name)])
})
US$abb <- as.factor(as.character(US$abb))

# Add counts per state to map.
US$count <- as.numeric(sapply(US$abb, function(abb) {
  countPerState[countPerState$abb == as.character(abb), 'freq']
}))

# For any states with no data, set their count to 0.
US$count[is.na(US$count)] <- 0

# Plot US map simple, no alpha fill, no labels.
p <- ggplot(US, aes( x = long , y = lat, group=group) ) +
  geom_polygon( colour = "green", fill= 'lightgreen' ) +
  expand_limits( x = US$long, y = US$lat ) +
  coord_fixed() +
  geom_path( data = states , colour = "white")

# Hide x and y axis tick mark labels.
p <- p + theme(
  axis.text.x = element_blank(),
  axis.text.y = element_blank(),
  axis.ticks = element_blank())

# Plot points.
p <- p + geom_point(data=data, aes(x=lon, y=lat), colour="red", fill="Pink",pch=21, size=3, alpha=I(0.7))
p <- p + xlab('JCPenney Store Closings') + ylab('')
p


# Plot US map detailed.
p <- ggplot(US, aes(x = long, y = lat, group=group)) +
  geom_polygon(fill='lightgreen', aes(alpha=count)) +
  geom_path() +
  coord_fixed() +
  guides(alpha=FALSE)

# Hide x and y axis tick mark labels.
p <- p + theme(
  axis.text.x = element_blank(),
  axis.text.y = element_blank(),
  axis.ticks = element_blank())

# Plot points.
p <- p + geom_point(data=data, aes(x=lon, y=lat), colour="red", fill="pink", pch=21, size=3, alpha=I(0.7))
p <- p + geom_text(data=data, aes(x=lon, y=lat, label=Mall), size=2.2, colour="black", hjust=-0.09, vjust=0, alpha=I(1))
p <- p + xlab('JCPenney Store Closings') + ylab('')
p
