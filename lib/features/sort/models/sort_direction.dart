enum SortDirection {
  ascending,
  descending;

  SortDirection get other {
    return this == SortDirection.ascending
        ? SortDirection.descending
        : SortDirection.ascending;
  }
}
