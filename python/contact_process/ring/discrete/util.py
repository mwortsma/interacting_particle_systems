import numpy as np
import cPickle as pickle

def save_distribution(f,output_file):
	pickle.dump( f, open( output_file, "wb" ) )

def load_distribution(file):
	return pickle.load( open( file, "rb" ) )

def main():
	parser = argparse.ArgumentParser(description='Util')
    parser.add_argument('--simulate', action="store_true", default=False)
    parser.add_argument('-T', action="store", default=10, type=int)
    parser.add_argument('-p', action="store", default=(1.0 / 2), type=float)
    parser.add_argument('-q', action="store", default=(1.0 / 3), type=float)
    parser.add_argument('-n', action="store", default=5, type=int)
    parser.add_argument('--init', action="store", default=0.5, type=float)

    parser.add_argument('--generate_distribution',
                        action="store_true", default=False)
    parser.add_argument('--start_index', action="store", default=0, type=int)
    parser.add_argument('--end_index', action="store", default=1, type=int)
    parser.add_argument('--step_iters', action="store",
                        default=10000, type=int)
    parser.add_argument('--output_file', action="store", default="out.txt")
    args = parser.parse_args()

if __name__ == "__main__":
    main()