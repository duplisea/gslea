# Identify the vertex representing temperature (adjust the name if necessary)
temperature_vertex <- "warm water"

# Determine the outgoing edges from the temperature vertex
outgoing_edges <- E(clams)[from(temperature_vertex)]

# Update the weights of the outgoing edges to reflect an increase in temperature
new_weights <- E(clams)$weight
new_weights[outgoing_edges] <- new_weights[outgoing_edges] + 0.5  # Adjust the increase value as desired

# Assign the updated weights to the graph
E(clams)$weight <- new_weights
edge.weights.plotting= abs(E(clams)$weight)

# Plot the signed digraph with the updated weights
plot(
  clams,
  edge.width= edge.weights.plotting,
  edge.color= edge.colours,
  vertex.size= vertex.size,
  vertex.color= vertex.colours,
  vertex.label.cex= 0.5,
  edge.arrow.size=edge.arrow.size,
  edge.curved=edge.curved,
  #vertex.label.family= "sans",
  rescale=FALSE,
  layout= coords*1
)


#####################################


overall.influence= function(sdg, source.vertex="warm water",
                            target.vertex="Adult clam abundance"){
  # Define the source and target vertices
  source.vertex <- V(sdg)[source.vertex]
  target.vertex <- V(sdg)[target.vertex]

  # Find all possible paths from the source to the target
  all.paths= all_simple_paths(sdg, from = source.vertex, to = target.vertex)

  # Initialize variables
  path.means <- numeric(length(all.paths))

  # Step 2 and 3: Calculate path sums and average by number of edges
  for (i in 1:length(all.paths)) {
    path <- all.paths[[i]]
    path.weight <- mean(E(sdg, path=path)$weight)
    path.means[i] <- path.weight
  }
  path.means
}


# Calculate the path statistic before the increase in temperature
  clam.before= overall.influence(clams)

## TO DO
  # debug the influence function. I am still not sure it has the weights correct
  # compute stats for the influence on the network of an experiment: histogram of influence
  # Rank the influence of the different paths
  # path length vs influence
  # jacknife and boostrap for influence of convoluted paths
  # pair up the paths before and after the experiment, subtracting the null and then do the analysis

# Increase the edge weights from the source vertex to simulate temperature increase
outgoing_edges <- E(clams)[from(temperature_vertex)]

increased_weight <- 0.5  # Adjust this value based on your scenario
E(clams)$weight[from(source_vertex)] <- E(clams)$weight[from(source_vertex)] + increased_weight

# Calculate the path statistic after the increase in temperature
  clam.after= overall.influence(clams2)

# Compare the path statistics before and after the increase in temperature
net_impact <- path_statistic_after - path_statistic_before

# Print the result
cat("Net impact of temperature increase on clam population abundance:", net_impact, "\n")
