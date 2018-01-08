import numpy as np

def get_graph(graph_type,n):
	if graph_type == 'complete':
		return get_complete(n)
	if graph_type == 'ring':
		return get_ring(n)

def get_complete(n):
	G = {}
	for i in range(n):
		G[i] = [j for j in range(n) if j != i]
	return G,n-1

def get_ring(n):
	G = {}
	for i in range(n):
		G[i] = [(i-1)%n, (i+1)%n]
	return G,2