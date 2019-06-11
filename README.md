## Description
This repository enables solving the multiobjective biocatalytic strain design problem (ModCell) with different Multiobjective evolutionary algorithms (MOEA). An analysis pipeline to compare the performance of different MOEAs is also included.

If you use any part of this software please cite:

~~~
Garcia, S. & Trinh, C. T. Comparison of Multi-Objective Evolutionary Algorithms to Solve the Modular Cell Design Problem for Novel Biocatalysis. Processes 7, (2019).
~~~

Here is the citation in bibtex format:

~~~
@Article{	  garcia2019c,
  author	= {Garcia, Sergio and Trinh, Cong T.},
  title		= {Comparison of Multi-Objective Evolutionary Algorithms to
		  Solve the Modular Cell Design Problem for Novel
		  Biocatalysis},
  journal	= {Processes},
  volume	= {7},
  year		= {2019},
  number	= {6},
  article-number= {361},
  url		= {https://www.mdpi.com/2227-9717/7/6/361},
  issn		= {2227-9717},
  abstract	= {A large space of chemicals with broad industrial and
		  consumer applications could be synthesized by engineered
		  microbial biocatalysts. However, the current strain
		  optimization process is prohibitively laborious and costly
		  to produce one target chemical and often requires new
		  engineering efforts to produce new molecules. To tackle
		  this challenge, modular cell design based on a chassis
		  strain that can be combined with different product
		  synthesis pathway modules has recently been proposed. This
		  approach seeks to minimize unexpected failure and avoid
		  task repetition, leading to a more robust and faster strain
		  engineering process. In our previous study, we
		  mathematically formulated the modular cell design problem
		  based on the multi-objective optimization framework. In
		  this study, we evaluated a library of state-of-the-art
		  multi-objective evolutionary algorithms (MOEAs) to identify
		  the most effective method to solve the modular cell design
		  problem. Using the best MOEA, we found better solutions for
		  modular cells compatible with many product synthesis
		  modules. Furthermore, the best performing algorithm could
		  provide better and more diverse design options that might
		  help increase the likelihood of successful experimental
		  implementation. We identified key parameter configurations
		  to overcome the difficulty associated with multi-objective
		  optimization problems with many competing design
		  objectives. Interestingly, we found that MOEA performance
		  with a real application problem, e.g., the modular strain
		  design problem, does not always correlate with artificial
		  benchmarks. Overall, MOEAs provide powerful tools to solve
		  the modular cell design problem for novel biocatalysis.},
  doi		= {10.3390/pr7060361}
}
~~~


## Installation
1. Ensure that you meet the following dependencies:
	1. The release v1.1 or greater of the [ModCell](https://github.com/TrinhLab/ModCell2) package must be in your matlab path.
	2. [matlab_utils](https://github.com/TrinhLab/matlab_utils),  used to make figures.
2. Simply add the `compare-moea` files to your matlab path.

## Questions and help
[Open an issue](https://github.com/TrinhLab/compare-moea/issues/new) if you encounter an error or need assitance.

## Credits
Two external packages are included in this repository:

- [PlatEMO](https://github.com/BIMK/PlatEMO) (This package has been modified to enable ModCell compatibility and fix some errors)
- [Hypervolume calculator from Fonseca et al.](http://lopez-ibanez.eu/hypervolume#download)
