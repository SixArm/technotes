# Data mesh: goals, strategies, tactics

Credit: Data Mesh by Zhamek Dehgani

* Goal: Manage changes to data gracefully in a complex, volatile, and uncertain business environment.

  * Strategy: Align business, tech, and data.

	* Tactic: Create cross-functional business, tech, and data teams.

	* Tactic: Make each team responsible for long-term ownership of their data products.

  * Strategy: Close the gap between the operational and analytical data planes.

    * Tactic: Remove organization-wide pipelines and the two-plane data architecture. 

    * Tactic: Integrate applications and data products more closely through dumb pipes.

  * Strategy: Localize data changes to business domains.

    * Tactic: Localize maintenance and ownership of data products in their specific domains.

    * Tactic: Create clear contracts between domain-oriented data products to reduce impact of change.

  * Strategic: Reduce the accidental complexity of pipelines and copying of data

    * Tactical: Refactor pipelines and transformations into corresponding data products.

    * Tactical: Rescope the pipelines and transformations into internal implementations.

* Goal: Sustain agility in the face of growth.

  * Strategy: Remove centralized architectural bottlenecks.

  	* Tactic: Remove centralized data warehouses and data lakes.

  	* Tactic: Enable peer-to-peer data sharing of data products through their data interfaces.

  * Strategy: Reduce the coordination of data pipelines.

    * Tactic: Move from a top-level functional decomposition of pipeline architecture to a domain-oriented decomposition of architecture.

    * Tactic: Introduce explicit data contracts between domain-oriented data products.

  * Strategy: Reduce coordination of data governance.

    * Tactic: Delegate governance responsibilities to autonomous domains and their data product owners.

    * Automate governance policies as code embedded and verified by each data product quantum.

  * Strategy: Enable team autonomy.

    * Tactic: Give domain teams autonomy in moving fast independently.

    * Tactic: Balance team autonomy with computational standards to create interoperability and a globally consistent experience of the mesh.

    * Tactic: Provide domain-agnostic infrastructure capabilities in a self-serve manner to give domain teams autonomy.

* Goal: Increase value from data over cost.

  * Strategy: Abstract complexity with a data platform

    * Tactic: Create a data-developer-centric and a data-user-centric infrastructure to remove friction and hidden costs in data development and use journeys.

    * Tactic: Define open and standard interfaces for data products to reduce vendor integration complexity.

  * Strategy: Embed product thinking everywhere.

    * Tactic: Focus and measure success based on data user and developer happiness.

    * Tactic: Treat both data and the data platform as a product.

  * Strategy: Go beyond the boundaries of an organization.

    * Tactic: Share data across physical and logical boundaries of platforms and organizations.

    * Tactic: Provide internet-based data sharing contracts across data products.

