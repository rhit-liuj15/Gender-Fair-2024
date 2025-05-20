import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help: How to Use Gender Fair Ratings"),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: const [
              Text(
                "Using the Website",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "The Gender Fair Ratings website allows users to explore and compare gender fairness data across U.S. colleges and universities using clear filters, visuals, and ranking tools.\n\n"
                "Homepage Filters:\n"
                "Filter schools by typing U.S. state names and selecting school types (public or private). Filters can be combined freely, and results update automatically.\n\n"
                "School Search and Selection:\n"
                "Search for a specific school by name using the search bar. Clicking the box icon under \"Add To List\" selects a school for comparison. Once one or more schools are selected, toggling \"Show Only Selected\" filters the list to only display those chosen schools.\n\n"
                "Pagination Controls:\n"
                "At the bottom of the rankings table, navigate between pages using “Next/Previous” and “First/Last” buttons. Type a page number directly to jump to a specific section of the list.\n\n"
                "Sorting and Rankings:\n"
                "Each school receives a total score based on four weighted categories: Leadership, Policies & Pay, Safety, and Diversity. Schools are sorted by total score by default. Sort by any category by clicking the “Sort by” dropdown. If multiple schools receive the same total score, they are considered tied in rank and are listed with the same ranking number.\n\n"
                "Data Visualizations:\n"
                "Pie charts show gender and racial representation in both academic and non-academic staff.\n\n"
                "Bar charts show numeric values such as average salaries and incident rates. For Hate Crimes and Violence Against Women Act (VAWA) cases, each bar chart shows both the selected school’s value and the national average to offer a clear baseline comparison.\n\n"
                "Missing Data Display:\n"
                "If a school does not report data for a specific metric, the corresponding chart will show “N/A”.\n\n"
                "Raw Values, Not Percentiles:\n"
                "All numbers shown in charts and scores reflect real, reported values such as salaries in USD or incidents per 1,000 students. This makes each data point easy to interpret and compare directly with the national average.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
