#Organic Chemistry Translation: SMILES -> IUPAC

As a self-driving car and drone/UAV/military software engineer and team lead, it might seem a little strange that I'm submitting a piece of code that solves an organic chemistry problem, especially one written in Ruby. This code was written as an interview assignment, meant to test my ability to learn something I had zero experience with, in a language I had never used. I intend for this to show a clean piece of code with a creative solution, written to specification. If I can produce code this well in an advanced college-level biology domain, you can be sure that I will write incredible code on your team within my expertise. All of the drone and military work I've done is closed source; however, my self-driving car work will soon be extremely public through Udacity. 

Original Requirements:

- Accept as input: the name of a compound in Simplified Molecular-Input Line-Entry System (SMILES) format
- Then, give as output: the name of that compound in IUPAC Nomenclature
- You only need to correctly handle alkanes (simple hydrocarbons), which will greatly reduce the scope and complexity
- You only need to handle straight-chain and branched alkanes, i.e. no cyclics
- The interface to the application is not important (std in/out)
- Implement it in Ruby
- Include tests (rspec, testunit, or whatever you prefer)

I modeled my compound data structure as a directed graph, with each vertex representing a “carbon.” This way, the compound is stored in memory in a custom graph structure I created, and the code is developed with OOP in mind such that the addition of different functionality would be as easy as possible. I used an interesting method of storing the alkane and alkyl groups, using the prefixed name as a hash key to an array of their respective locants. This really cut down on potential space complexity and was the best way, I found, to rectify the issue of alphabetizing the groups without including the di/tri prefixes, unless of course it was a branched-branch. Oh, the joys of organic chemistry.

I really, really enjoyed this project, and I picked up on some pretty interesting concepts that I’ve bookmarked in my head for later, for when I run into similar problems that would be well suited for Ruby. Organic Chemistry is not my favorite subject, as there are way too many exceptions to the naming conventions (you can tell IUPAC wasn’t developed by a computer scientist), but I always enjoy learning more about the world, and I particularly liked the way I was able to create the DAG that corresponded to a physical, organic compound.​​ Definitely something I've never done, and it was a real pleasure.

TO RUN:

Command Line: ruby orgChem_v2.rb "CCC(C)CC(C)C(C(C)(CC)C)C(CC)CCCC”

Unit Test Cases: ruby tc_orgChem.rb


