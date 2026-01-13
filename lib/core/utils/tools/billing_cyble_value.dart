String billingCycleToValue(String billingCycle) {
  switch (billingCycle.toLowerCase()) {
    case "month":
      return "mois";
    case "year":
      return "année";
    case "day":
      return "jour";
    case "night":
      return "nuit";
    default:
      return "";
  }
}
