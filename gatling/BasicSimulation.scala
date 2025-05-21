import io.gatling.core.scenario.Simulation
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class BasicSimulation extends Simulation {

  val httpProtocol = http.baseUrl(System.getenv("HOST"))

  val scn: ScenarioBuilder = scenario("Load Test")
    .exec(
      http("GET Request")
        .get("/")
        .check(status.is(200))
    )
    .pause(1)

  setUp(
    scn.inject(
      rampUsers(System.getenv("NUM_USERS").toInt) during (System.getenv("TEST_DURATION").toInt.seconds)
    )
  ).protocols(httpProtocol)
}
