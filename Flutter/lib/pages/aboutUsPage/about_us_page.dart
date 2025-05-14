import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Gender Fair Ratings"),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              const Text(
                "Data Sources",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "We used three databases in our project to create the rankings:\n\n"
                "Integrated Postsecondary Education Data System (IPEDS): Annual surveys conducted by the National Center for Education Statistics, part of the U.S. Department of Education, collect a wide range of financial, admissions/enrollment, student body, and staff data from all institutions that participate in federal financial assistance programs authorized by Title IV of the Higher Education Act of 1965.\n\n"
                "Campus Safety and Security (CSS): This database, produced by the Office of Postsecondary Education within the U.S. Department of Education, provides campus crime and fire data from all institutions receiving Title IV funding.\n\n"
                "Internal Revenue Service (IRS): This data source provides financial information about the highest-ranking executives in various organizations, as well as data on whistleblower policies and compensation reviews—not limited to educational institutions. All private universities and public charitable foundations supporting public universities are required to submit IRS Form 990 annually.",
              ),
              const SizedBox(height: 24),
              const Text(
                "Scoring",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(5),
                },
                border: TableBorder.all(color: Colors.grey),
                children: const [
                  TableRow(
                    decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Category",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Weight",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Distribution",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Leadership"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("30%"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Academic Staff Gender Composition (30%)"),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Policies & Pay"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("25%"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          "Average Pay by Gender (15%), Campus Daycare (10%, not shown)"),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Safety"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("20%"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("VAWA Incidents (10%), Hate Crimes (10%)"),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Diversity"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("25%"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          "Racial Diversity of Academic Staff (20%), Non-Academic Staff (5%)"),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "We chose these weightings and data point allocations for each category based on client needs and data integrity. The availability of racial and gender data in IPEDS contributed to the high weight of the Leadership and Diversity categories.\n\n"
                "Although average pay data by gender for top executives was only available from IRS Form 990s—submitted by approximately 30% of institutions—we included it where possible. We also incorporated campus daycare policies to assess institutional readiness and flexibility for women with children.\n\n"
                "Safety data was drawn from CSS datasets documenting crimes classified under the Violence Against Women Act and hate crimes against women. Notably, CSS categorized these separately.\n\n"
                "Altogether, these considerations help provide a more holistic view of gender fairness across executives, students, and staff.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
