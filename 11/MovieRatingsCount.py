from mrjob.job import MRJob
from mrjob.step import MRStep

class MovieRatingsCount(MRJob):
    def steps(self):
        return [
            MRStep(mapper=self.mapper_get_movieids,
                   reducer=self.reducer_count_ratings),
            MRStep(reducer=self.reducer_sort_counts)
        ]

    def mapper_get_movieids(self, _, line):
        try:
            userID, movieID, rating, timestamp = line.split('\t')
            yield movieID, 1
        except ValueError:
            pass  # ignora linhas mal formatadas

    def reducer_count_ratings(self, movieID, counts):
        yield None, (sum(counts), movieID)

    def reducer_sort_counts(self, _, count_movieid_pairs):
        for count, movieID in sorted(count_movieid_pairs, reverse=True):
            yield count, movieID

if __name__ == '__main__':
    MovieRatingsCount.run()
